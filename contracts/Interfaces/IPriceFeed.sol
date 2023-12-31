// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

interface IPriceFeed {
    function fetchPrice() external returns (uint);
}
