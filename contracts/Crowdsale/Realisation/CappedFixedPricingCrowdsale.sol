// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.17;

import "./../FixedPricingCrowdsale.sol";
import "../../FundingStrategy/CappedFundingStrategy.sol";

contract CappedFixedPricingCrowdsale is FixedPricingCrowdsale {

    /// ----------------
    /// Public methods |
    /// ----------------

    /**
    * @notice Constructs CappedFixedPricingCrowdsale contract.
    * @param _startTime time when crowdsale starts,
    * @param _endTime time when crowdsale ends,
    * @param _weiTokenPrice price of token in wei,
    * @param _etherInvestmentObjective target sum of investements for finishing crowdsale.
    */
    constructor(uint256 _startTime, uint256 _endTime,
                uint256 _weiTokenPrice, uint256 _etherInvestmentObjective) 
                FixedPricingCrowdsale(_startTime, _endTime, _weiTokenPrice, _etherInvestmentObjective) payable {}

    /// -----------------
    /// Internal methods|
    /// -----------------

    function createFundingLimitStrategy() internal override returns (FundingLimitStrategy) {
        return new CappedFundingStrategy(100 * 1000000000000000000);
    }
}