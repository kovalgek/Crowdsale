// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.17;

import "./FundingLimitStrategy.sol";

contract CappedFundingStrategy is FundingLimitStrategy {

    uint256 private fundingCup;

    constructor (uint256 _fundingCup) {
        require(_fundingCup > 0);

        fundingCup = _fundingCup;
    }

    function isFullInvestmentWithinLimit(uint256 _investment, uint256 _fullInvestmentReceived) public override view returns (bool) {
        return _fullInvestmentReceived + _investment < fundingCup;
    }
}