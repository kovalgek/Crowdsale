// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.17;

import "./../Utilities/Pausable.sol";
import "./../Utilities/Destructible.sol";
import "./../Coin/ReleasableSimpleCoin.sol";

/**
 * @title Contract for controling crowdsale.
 */
contract SimpleCrowdsale is Pausable, Destructible {

    uint256 private startTime;
    uint256 private endTime;
    uint256 internal weiTokenPrice;
    uint256 private weiInvestmentObjective;
    mapping(address => uint256) private investmentAmountOf;
    uint256 internal investmentReceived;
    uint256 private investmentRefunded;
    bool private isFinalized;
    bool private isRefundingAllowed;
    ReleasableSimpleCoin private crowdsaleToken;

    event LogInvestment(address indexed _investor, uint256 _value);
    event LogTokenAssignment(address indexed _investor, uint256 _tokens);
    event Refund(address investor, uint256 value);

    /// ------------------------------------------
    /// Public methods
    /// ------------------------------------------

    /**
    * @notice Constructs SimpleCrowdsale contract.
    * @param _startTime time when crowdsale starts,
    * @param _endTime time when crowdsale ends,
    * @param _weiTokenPrice price of token in wei,
    * @param _etherInvestmentObjective target sum of investements for finishing crowdsale.
    */
    constructor(uint256 _startTime, uint256 _endTime, uint256 _weiTokenPrice, uint256 _etherInvestmentObjective) {
        require(_startTime >= block.timestamp);
        require(_startTime <= _endTime);
        require(_weiTokenPrice != 0);
        require(_etherInvestmentObjective != 0);

        startTime = _startTime;
        endTime = _endTime;
        weiTokenPrice = _weiTokenPrice;
        weiInvestmentObjective = _etherInvestmentObjective * 1000000000000000000;
        crowdsaleToken = new ReleasableSimpleCoin(0);
        isFinalized = false;
        isRefundingAllowed = false;
    }

    /**
    * @notice a payable function for investment.
    */
    function invest() public payable {
        require(isValidInvestment(msg.value), "Invalid investment");

        address investor = msg.sender;
        uint256 investment = msg.value;

        investmentAmountOf[investor] += investment;
        investmentReceived += investment;

        assignTokens(investor, investment);
        emit LogInvestment(investor, investment);
    }
    
    /**
    * @notice finalizes if possible crowdsaling.
    */
    function finalize() public {
        if(isFinalized) {
            revert("Can't finalize twice");
        }

        bool isCrowdsaleComplete = block.timestamp > endTime;
        bool investmentObjectiveMet = investmentReceived >= weiInvestmentObjective;

        if (isCrowdsaleComplete) {
            if (investmentObjectiveMet) {
                crowdsaleToken.release();
            } else {
                isRefundingAllowed = true;
            }
            isFinalized = true;
        }
    }

    /**
    * @notice refunds money back to investor.
    */
    function refund() public {
        if (!isRefundingAllowed) {
            revert("Refunding isn't allowed yet");
        }

        address investor = msg.sender;
        uint256 investment = investmentAmountOf[investor];
        if (investment == 0) {
            revert("Account didn't invest");
        }
        investmentAmountOf[investor] = 0;
        investmentRefunded += investment;

        payable(investor).transfer(investment);

        emit Refund(investor, investment);
    }
    
    /// ------------------------------------------
    /// Internal methods
    /// ------------------------------------------

    function isValidInvestment(uint256 _investment) internal view returns (bool) {
        bool nonZeroInvestment = _investment != 0;
        bool withinCrowdsalePeriod = block.timestamp >= startTime && block.timestamp <= endTime;
        return nonZeroInvestment && withinCrowdsalePeriod;
    }

    function assignTokens(address _beneficiary, uint256 _investment) internal {
        uint256 numberOfTokens = calculateNumberOfTokens(_investment);
        crowdsaleToken.mint(_beneficiary, numberOfTokens);
    }

    function calculateNumberOfTokens(uint256 _investment) internal virtual returns (uint256) {
        return _investment / weiTokenPrice;
    }
}