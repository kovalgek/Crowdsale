// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.17;

import "./SimpleCrowdsale.sol";

/**
 * @title Contract for controling crowdsale that uses dynamic number of tokens.
 */
abstract contract TranchePricingCrowdsale is SimpleCrowdsale  {
    
    struct Tranche {
        uint256 weiHighLimit;
        uint256 weiTokenPrice;
    }
    
    mapping(uint256 => Tranche) private trancheStructure;
    uint256 private currentTrancheLevel;

    /// ----------------
    /// Public methods |
    /// ----------------

    /**
    * @notice Constructs SimpleCrowdsale contract.
    * @param _startTime time when crowdsale starts,
    * @param _endTime time when crowdsale ends,
    * @param _etherInvestmentObjective target sum of investements for finishing crowdsale.
    */
    constructor(uint256 _startTime, uint256 _endTime, uint256 _etherInvestmentObjective) 
        SimpleCrowdsale(_startTime, _endTime,  1, _etherInvestmentObjective) {
            
        trancheStructure[0] = Tranche(3000 ether, 0.002 ether);
        trancheStructure[1] = Tranche(10000 ether, 0.003 ether);
        trancheStructure[2] = Tranche(15000 ether, 0.004 ether);
        trancheStructure[3] = Tranche(1000000000 ether, 0.005 ether);
        
        currentTrancheLevel = 0;
    } 
    
    /// -----------------
    /// Internal methods|
    /// -----------------

    function calculateNumberOfTokens(uint256 investment) override internal returns (uint256) {
        updateCurrentTrancheAndPrice();
        return investment / weiTokenPrice; 
    }

    function updateCurrentTrancheAndPrice() internal {
        uint256 i = currentTrancheLevel;

        while(trancheStructure[i].weiHighLimit < investmentReceived)
            ++i;
          
        currentTrancheLevel = i;
        weiTokenPrice = trancheStructure[currentTrancheLevel].weiTokenPrice;
   }
}