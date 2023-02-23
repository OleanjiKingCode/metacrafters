//SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TestToken is ERC20("TestToken", "Tst") {
    //address of the deployer
    address ownerAddress;
    
    constructor(uint totalSupply) {
        uint amount = totalSupply * 10 ** 18;
        ownerAddress = msg.sender;
        _mint(ownerAddress, amount);
    }
}
