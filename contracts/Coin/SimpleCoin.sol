// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.17;

import "./../Ownable.sol";

contract SimpleCoin is Ownable {
    mapping(address => uint256) coinBalance;
    mapping(address => mapping(address => uint256)) allowance;
    mapping(address => bool) frozenAccount;

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event FrozenAccount(address _target, bool _frozen);

    constructor(uint256 _initialSupply) {
        mint(owner, _initialSupply);
    }

    function mint(address _recipient, uint256 _mintedAmount) public onlyOwner {
        coinBalance[_recipient] += _mintedAmount;
        emit Transfer(owner, _recipient, _mintedAmount);
    }

    function freezeAccount(address _target, bool _freeze) public onlyOwner {
        frozenAccount[_target] = _freeze;
        emit FrozenAccount(_target, _freeze);
    }

    function transfer(address _to, uint256 _amount) virtual public {
        require(coinBalance[msg.sender] > _amount);
        require(coinBalance[_to] + _amount >= coinBalance[_to]);

        coinBalance[msg.sender] -= _amount;
        coinBalance[_to] += _amount;

        emit Transfer(msg.sender, _to, _amount);
    }

    function authorize(address _authorizedAccount, uint256 _allowance) public {
        allowance[msg.sender][_authorizedAccount] = _allowance;
    }

    function transferFrom(address _from, address _to, uint256 _amount) virtual public {
        require(coinBalance[_from] > _amount);
        require(coinBalance[_to] + _amount >= coinBalance[_to]);
        require(_amount <= allowance[_from][msg.sender]);

        coinBalance[_from] -= _amount;
        coinBalance[_to] += _amount;
        allowance[_from][msg.sender] -= _amount;

        emit Transfer(_from, _to, _amount);
    }
}