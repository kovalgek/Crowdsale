// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.17;

import "./SimpleCoin.sol";

contract ReleasableSimpleCoin is SimpleCoin {
    
    bool released = false; 

    modifier isReleased {
        if (!released) {
            revert();
        }

        _;
    }

    constructor(uint256 _initialSupply) SimpleCoin(_initialSupply) {}

    function release() public onlyOwner {
        released = true;
    }

    function transfer(address _to, uint256 _amount) public override isReleased {
        super.transfer(_to, _amount);
    }

    function transferFrom(address _from, address _to, uint256 _amount) public override isReleased {
        super.transferFrom(_from, _to, _amount);
    }
}