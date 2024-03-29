// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.17;

import "./../TranchePricingCrowdsale.sol";
import "../../FundingStrategy/UnlimitedFundingStrategy.sol";

contract UnlimitedTranchePricingCrowdsale is TranchePricingCrowdsale {
    
    /// ----------------
    /// Public methods |
    /// ----------------

    /**
    * @notice Constructs UnlimitedTranchePricingCrowdsale contract.
    * @param _startTime time when crowdsale starts,
    * @param _endTime time when crowdsale ends,
    * @param _etherInvestmentObjective target sum of investements for finishing crowdsale.
    */
    constructor(uint256 _startTime, uint256 _endTime,
                uint256 _etherInvestmentObjective) 
                TranchePricingCrowdsale(_startTime, _endTime, _etherInvestmentObjective) payable {}

    /// -----------------
    /// Internal methods|
    /// -----------------

    function createFundingLimitStrategy() internal override returns (FundingLimitStrategy) {
        return new UnlimitedFundingStrategy();
    }
}