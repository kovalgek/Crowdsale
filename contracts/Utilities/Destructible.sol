// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.17;

import "./Ownable.sol";

contract Destructible is Ownable {
    
    constructor() payable { } 
    
    function destroyAndSend(address payable _recipient) onlyOwner public {
        selfdestruct(_recipient);
    }
}