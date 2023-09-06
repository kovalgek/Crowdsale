// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.17;

import "./FundingLimitStrategy.sol";

contract CappedFundingStrategy is FundingLimitStrategy {

    uint256 private fundingCup;

    /// ----------------
    /// Public methods |
    /// ----------------

    /**
    * @notice Constructs CappedFundingStrategy contract.
    * @param _fundingCup limit in wei.
    */
    constructor (uint256 _fundingCup) {
        fundingCup = _fundingCup;
    }

    function isFullInvestmentWithinLimit(uint256 _investment, uint256 _fullInvestmentReceived) public override view returns (bool) {
        return _fullInvestmentReceived + _investment < fundingCup;
    }
}