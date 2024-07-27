// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import '@openzeppelin/contracts/token/ERC20/ERC20.sol';

contract Token is ERC20 {
    constructor(
        string memory name, 
        string memory ticker
    ) 
        ERC20(name, ticker) 
    {
        _mint(msg.sender, 1);
    }
}
