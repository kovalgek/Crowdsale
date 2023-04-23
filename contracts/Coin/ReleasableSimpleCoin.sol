// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.17;

import "./SimpleCoin.sol";
import "./../Utilities/Pausable.sol";
import "./../Utilities/Destructible.sol";

contract ReleasableSimpleCoin is SimpleCoin, Pausable, Destructible {
    
    bool private released = false; 

    modifier isReleased {
        if (!released) {
            revert("Contract isn't released yet");
        }

        _;
    }
    
    /**
    * @notice Constructs contract
    * @param _initialSupply initial coins amount.
    */
    constructor(uint256 _initialSupply) SimpleCoin(_initialSupply) {}

    /**
    * @notice Releases contract and allow to use other methods.
    */
    function release() public onlyOwner {
        released = true;
    }

    /**
    * @notice Transfers coins from sender to another account when contract released.
    * @param _to an account that receives coins,
    * @param _amount: an amount of transfered coins.
    */
    function transfer(address _to, uint256 _amount) public override isReleased {
        super.transfer(_to, _amount);
    }

    /**
    * @notice Transfers coins from `_from` to `_to` account when contract released.
    * @param _from an account from whome coins are taken,
    * @param _to an account that receives coins,
    * @param _amount an amount of transfered coins.
    */
    function transferFrom(address _from, address _to, uint256 _amount) public override isReleased {
        super.transferFrom(_from, _to, _amount);
    }
}