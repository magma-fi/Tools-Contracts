// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./Interfaces/IBorrowerOperations.sol";
import "./Interfaces/IMimoV2Router02NoReferral.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract SwapAndCloseTool {
    using Address for address;
    using SafeERC20 for IERC20;

    IBorrowerOperations public borrowerOperations;
    ITroveManager public troveManager;
    IMimoV2Router02NoReferral public mimoRouter;
    IERC20 public WEN;
    address public WETH;

    constructor(address _borrowerOperations, address _mimoRouter) {
        require(_borrowerOperations.isContract(), "SwapAndCloseTool: borrowerOperations is not contract");
        require(_mimoRouter.isContract(), "SwapAndCloseTool: mimoRouter is not contract");

        borrowerOperations = IBorrowerOperations(_borrowerOperations);
        troveManager = borrowerOperations.troveManager();
        mimoRouter = IMimoV2Router02NoReferral(_mimoRouter);
        WEN = IERC20(borrowerOperations.lusdToken());
        WETH = mimoRouter.WETH();

        WEN.approve(address(borrowerOperations), type(uint256).max);
    }

    function swapAndCloseTrove() payable external {
        uint debt = troveManager.getTroveDebt(msg.sender);
        require(debt > 0, "SwapAndCloseTool: debt is 0");
        debt = debt - borrowerOperations.LUSD_GAS_COMPENSATION();

        uint256 balance = WEN.balanceOf(msg.sender);
        uint256 transferIn = balance >= debt ? debt : balance;
        if (transferIn > 0) {
            WEN.safeTransferFrom(msg.sender, address(this), transferIn);
        }

        if (WEN.balanceOf(address(this)) < debt) {
            uint256 amountOut = debt - WEN.balanceOf(address(this));
            // swap
            address[] memory path = new address[](2);
            path[0] = WETH;
            path[1] = address(WEN);
            uint256[] memory amounts = mimoRouter.getAmountsIn(amountOut, path);
            require(msg.value >= amounts[0], "SwapAndCloseTool: ETH is not enough");

            mimoRouter.swapETHForExactTokens{value: amounts[0]}(amountOut, path, address(this), block.timestamp + 10);
        }

        // close trove
        borrowerOperations.closeTroveOnBehalf(msg.sender);
        if(address(this).balance > 0) {
            (bool success, ) = msg.sender.call{ value: address(this).balance }("");
            require(success, "SwapAndCloseTool: sending ETH failed");
        }
    }
}
