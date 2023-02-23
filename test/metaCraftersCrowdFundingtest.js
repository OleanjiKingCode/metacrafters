const { ethers } = require("hardhat");
const { assert } = require("chai");

describe("Crowdfunding", function () {
    
  it("should allow users to pledge funds to the project and allow the project owner to withdraw funds when the funding goal is met", async function () {
    //GET TESTOKEN DEPLOYED TO USE IN OTHER TESTING
    const Token = await ethers.getContractFactory("TestToken");
    const token = await Token.deploy("10000");
    await token.deployed();
    const CA = token.address;
    console.log(CA);

    // Get signers
    const [deployer, user1, user2, user3] = await ethers.getSigners();

    // Deploying the contract
    const Crowdfunding = await ethers.getContractFactory("Crowdfunding");
    const crowdfunding = await Crowdfunding.deploy(CA, user3.address, 100);

    // // Set the token contract address in the crowdfunding contract
    // await token.setApprovalForAll(crowdfunding.address, true);

    // Connect to the contract using the signer for user1
    const contract = crowdfunding.connect(user1);
    const contract2 = crowdfunding.connect(user1);

    token.transfer(user1.address, 80);
    token.transfer(user2.address, 40);
    const values = await token.balanceOf(user1.address);
    console.log(values);

    // Pledge 50 tokens from user1 and 50 tokens from user2
    await token.connect(user1).approve(crowdfunding.address, 70);

    await contract.pledgeFunds(70);

    await token.connect(user2).approve(crowdfunding.address, 30);
    await contract2.connect(user2).pledgeFunds(30);

    // Check that the user's pledge was recorded correctly
    assert.equal(await contract.accumulatedFunds(user1.address), 70);

    // Check that the total funds raised is 100
    assert.equal(await contract.totalFundsRaised(), 100);

    // Connect to the contract using the signer for the project owner
    const ownerContract = crowdfunding.connect(user3);

    // Withdraw the funds
    await ownerContract.withdrawFunds();

    // Check that the project owner received the funds
    assert.equal(await token.balanceOf(user3.address), 100);
  });
});
