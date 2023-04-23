// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.17;

import "./SimpleCrowdsale.sol";

abstract contract FixedPricingCrowdsale is SimpleCrowdsale {

    /// ----------------
    /// Public methods |
    /// ----------------

    /**
    * @notice Constructs SimpleCrowdsale contract.
    * @param _startTime time when crowdsale starts,
    * @param _endTime time when crowdsale ends,
    * @param _weiTokenPrice price of token in wei,
    * @param _etherInvestmentObjective target sum of investements for finishing crowdsale.
    */
    constructor(uint256 _startTime, uint256 _endTime,
                uint256 _weiTokenPrice, uint256 _etherInvestmentObjective) 
                SimpleCrowdsale(_startTime, _endTime, _weiTokenPrice, _etherInvestmentObjective) payable {}

    /// -----------------
    /// Internal methods|
    /// -----------------

    function calculateNumberOfTokens(uint256 _investment) internal override view returns (uint256) {
        return _investment / weiTokenPrice;
    }
}