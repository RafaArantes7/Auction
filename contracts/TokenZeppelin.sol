// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/AccessControl.sol";

contract Token is ERC20, AccessControl {
    
    bytes32 public  constant MINTER_ROLE = keccak256("MINTER_ROLE");
    constructor(address minter) ERC20("Dradon ball Z", "DBZ") {
        _grantRole(MINTER_ROLE, minter);
    }

    function mint(address to, uint256 amount) public {
        require(hasRole(MINTER_ROLE, msg.sender), "Only minter");
        _mint(to, amount);
    }

}

