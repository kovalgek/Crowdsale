const { expect } = require("chai");
const hre = require("hardhat");
const { loadFixture } = require("@nomicfoundation/hardhat-network-helpers");

describe("ReleasableSimpleCoin", function() {

    async function deploySimpleCoinFixture() {

        // Contracts are deployed using the first signer/account by default
        const [owner, account1, account2] = await ethers.getSigners();
    
        const TEN_COINS = 10;
        const initialSupply = TEN_COINS;

        const ReleasableSimpleCoin = await ethers.getContractFactory("ReleasableSimpleCoin");
        const releasableSimpleCoin = await ReleasableSimpleCoin.deploy(initialSupply);
    
        return { releasableSimpleCoin, initialSupply, owner, account1, account2 };
      }

    it("Should release contract before usage", async function() {
        const { releasableSimpleCoin, owner, account1, account2} = await loadFixture(deploySimpleCoinFixture);

        await expect(releasableSimpleCoin.transfer(account1.address, 2)).to.be.revertedWith("Contract isn't released yet");
        await expect(releasableSimpleCoin.transfer(account2.address, 2)).to.be.revertedWith("Contract isn't released yet");
    });

    it("Should be able to use contract after release", async function() {
        const { releasableSimpleCoin, owner, account1, account2} = await loadFixture(deploySimpleCoinFixture);

        await releasableSimpleCoin.release();

        await expect(releasableSimpleCoin.transfer(account1.address, 2)).not.to.be.reverted;
        await expect(releasableSimpleCoin.transfer(account2.address, 2)).not.to.be.reverted;
    });
});