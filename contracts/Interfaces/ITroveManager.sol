// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

interface ITroveManager {
    function getEntireDebtAndColl(address _borrower) external view returns (
        uint debt, 
        uint coll, 
        uint pendingLUSDDebtReward, 
        uint pendingETHReward
    );

    function getTroveDebt(address _borrower) external view returns (uint);
}
