//SPDX-License-Identifier: MIT

pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/// @title Test token
/// @author Oleanji
/// @notice This contract is used as a test token to test the crowd funding contract
contract TestToken is ERC20("TestToken", "Tst") {
    
    //address of the deployer
    address ownerAddress;

    /// -----------------------------------------------------------------------
    /// Constructor
    /// -----------------------------------------------------------------------
    constructor(uint totalSupply) {
        uint amount = totalSupply * 10 ** 18;
        ownerAddress = msg.sender;
        _mint(ownerAddress, amount);
    }
}
