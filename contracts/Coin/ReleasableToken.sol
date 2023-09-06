// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.17;

interface ReleasableToken {
    function mint(address _beneficiary, uint256 _numberOfTokens) external;
    function release() external;
    function transfer(address _to, uint256 _amount) external;
}