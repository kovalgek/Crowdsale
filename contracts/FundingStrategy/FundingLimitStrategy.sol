// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.17;

abstract contract FundingLimitStrategy {
    function isFullInvestmentWithinLimit(uint256 _investment, uint256 _fullInvestmentReceived) public virtual view returns (bool);
}