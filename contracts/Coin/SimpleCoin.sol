// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.17;

import "./../Ownable.sol";

contract SimpleCoin is Ownable {
    mapping(address => uint256) private coinBalance;
    mapping(address => mapping(address => uint256)) private allowance;

    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    /**
    * @notice Constructs contract
    * @param _initialSupply initial coins amount.
    */
    constructor(uint256 _initialSupply) {
        mint(owner, _initialSupply);
    }

    /**
    * @notice Mints coins
    * @param _recipient an account that receives coins,
    * @param _mintedAmount: an amounted of received coins.
    */
    function mint(address _recipient, uint256 _mintedAmount) public onlyOwner {
        coinBalance[_recipient] += _mintedAmount;
        emit Transfer(owner, _recipient, _mintedAmount);
    }

    /**
    * @notice Returns balance of `_account`
    * @param _account account that ballance is requested.
    */
    function balanceOf(address _account) public view returns (uint256) {
        return coinBalance[_account];
    }

    /**
    * @notice Transfers coins from sender to another account
    * @param _to an account that receives coins,
    * @param _amount: an amount of transfered coins.
    */
    function transfer(address _to, uint256 _amount) virtual public {
        require(coinBalance[msg.sender] > _amount);
        require(coinBalance[_to] + _amount >= coinBalance[_to]);

        coinBalance[msg.sender] -= _amount;
        coinBalance[_to] += _amount;

        emit Transfer(msg.sender, _to, _amount);
    }

    /**
    * @notice Transfers coins from `_from` to `_to` account.
    * @param _from an account from whome coins are taken,
    * @param _to an account that receives coins,
    * @param _amount an amount of transfered coins.
    */
    function transferFrom(address _from, address _to, uint256 _amount) virtual public {
        require(coinBalance[_from] > _amount);
        require(coinBalance[_to] + _amount >= coinBalance[_to]);
        // require(_amount <= allowance[_from][msg.sender]);

        coinBalance[_from] -= _amount;
        coinBalance[_to] += _amount;
        // allowance[_from][msg.sender] -= _amount;

        emit Transfer(_from, _to, _amount);
    }

    /**
    * @notice Authorizes account for managing its coins.
    * @param _authorizedAccount an account that is going to be authorized,
    * @param _allowance amount of coints that will be allowed to manage for authorized account.
    */
    function authorize(address _authorizedAccount, uint256 _allowance) public {
        allowance[msg.sender][_authorizedAccount] = _allowance;
    }
}