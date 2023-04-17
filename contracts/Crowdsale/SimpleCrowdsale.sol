// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.17;

import "./../Ownable.sol";
import "./../Coin/ReleasableSimpleCoin.sol";

contract SimpleCrowdsale is Ownable {

    uint256 startTime;
    uint256 endTime;
    uint256 weiTokenPrice;
    uint256 weiInvestmentObjective;
    mapping(address => uint256) investmentAmountOf;
    uint256 investmentReceived;
    uint256 investmentRefunded;
    bool isFinalized;
    bool isRefundingAllowed;
    ReleasableSimpleCoin crowdsaleToken;

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

    event LogInvestment(address indexed _investor, uint256 _value);
    event LogTokenAssignment(address indexed _investor, uint256 _tokens);

    function invest() public payable {
        require(isValidInvestment(msg.value));

        address investor = msg.sender;
        uint256 investment = msg.value;

        investmentAmountOf[investor] += investment;
        investmentReceived += investment;

        assignTokens(investor, investment);
        emit LogInvestment(investor, investment);
    }

    function isValidInvestment(uint256 _investment) internal pure returns (bool) {
        bool nonZeroInvestment = _investment != 0;
        bool withinCrowdsalePeriod = true; //block.timestamp >= startTime && block.timestamp <= endTime;
        return nonZeroInvestment && withinCrowdsalePeriod;
    }

    function assignTokens(address _beneficiary, uint256 _investment) internal {
        uint256 numberOfTokens = calculateNumberOfTokens(_investment);
        crowdsaleToken.mint(_beneficiary, numberOfTokens);
    }

    function calculateNumberOfTokens(uint256 _investment) internal view returns (uint256) {
        return _investment / weiTokenPrice;
    }
    
    function finalize() public {
        if(isFinalized) {
            revert();
        }

        bool isCrowdsaleComplete = true; //block.timestamp > endTime;
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

    event Refund(address investor, uint256 value);

    function refund() public {
        if (!isRefundingAllowed) {
            revert();
        }

        address investor = msg.sender;
        uint256 investment = investmentAmountOf[investor];
        if (investment == 0) {
            revert();
        }
        investmentAmountOf[investor] = 0;
        investmentRefunded += investment;

        payable(investor).transfer(investment);

        emit Refund(investor, investment);
    }
}