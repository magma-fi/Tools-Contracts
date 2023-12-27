// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./ITroveManager.sol";
import "./IPriceFeed.sol";

interface IBorrowerOperations {
    function closeTroveOnBehalf(address troveOwner) external;
    function troveManager() external view returns(ITroveManager);
    function LUSD_GAS_COMPENSATION() external view returns(uint);
    function lusdToken() external view returns(address);
    function priceFeed() external view returns(IPriceFeed);
}
