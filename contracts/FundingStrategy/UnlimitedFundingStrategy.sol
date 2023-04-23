// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.17;

import "./FundingLimitStrategy.sol";

contract UnlimitedFundingStrategy is FundingLimitStrategy {
    function isFullInvestmentWithinLimit(uint256, uint256) public override pure returns (bool) {
        return true;
    }
}