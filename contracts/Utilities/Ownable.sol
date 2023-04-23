// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.17;

/**
 * @title Ownable entity.
 *
 * Allows to set up contract owner and restrict methods by modifier.
 */
contract Ownable {
    address internal owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Only contract owner can call this function");
        _;
    }
}