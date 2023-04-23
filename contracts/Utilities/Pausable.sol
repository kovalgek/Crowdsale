// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.17;

import "./Ownable.sol";

contract Pausable is Ownable { 
    bool public paused = false;

    modifier whenNotPaused() {
        require(!paused);
        _;
    }

    modifier whenPaused() {
        require(paused);
        _;
    }

    function pause() onlyOwner 
        whenNotPaused public {
        paused = true;
    }

    function unpause() onlyOwner 
        whenPaused public {
        paused = false;
    }
}