// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.17;

contract Ownable {
    address owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Only contract owner can call this function");
        _;
    }
}