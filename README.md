# Crowdfunding Contract using Solidity and OpenZeppelin Contracts

This is a smart contract written in Solidity for a crowdfunding application. The contract allows users to pledge funds to a crowdfunding campaign, and refunds their funds if the campaign's funding goal is not met. The funds take the form of a custom ERC20 token, which is used to track and transfer the pledged funds.

The contract uses the OpenZeppelin Contracts library to implement standard ERC20 functionality and safe math operations. It also uses the Chai testing library for writing and running tests.

## Technologies Used

- Solidity
- Hardhat
- OpenZeppelin Contracts
- Chai

## Installation

To use this contract and run the tests, you'll need to have Node.js and npm installed on your system. Then, follow these steps:

1. Clone this repository to your local machine.
2. Navigate to the project directory in your terminal.
3. Run `npm install` to install the required dependencies.

## Usage

To deploy the contract and interact with it, you'll need to set up a development environment using Hardhat. Follow the instructions in the [Hardhat documentation](https://hardhat.org/getting-started/) to get started.


To run the tests, use the `npm test` command. This will run the test suite defined in the `test/crowdfunding.js` file, using the Chai testing library.


