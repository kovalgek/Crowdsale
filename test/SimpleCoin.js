const { expect } = require("chai");
const hre = require("hardhat");
const { loadFixture } = require("@nomicfoundation/hardhat-network-helpers");

describe("SimpleCoint", function() {

    async function deploySimpleCoinFixture() {

        const [owner, account1, account2] = await ethers.getSigners();
    
        const TEN_COINS = 10;
        const initialSupply = TEN_COINS;

        const SimpleCoin = await ethers.getContractFactory("SimpleCoin");
        const simpleCoin = await SimpleCoin.deploy(initialSupply);
    
        return { simpleCoin, initialSupply, owner, account1, account2 };
    }

    it("Should init owner with coins", async function() {
        const { simpleCoin, owner} = await loadFixture(deploySimpleCoinFixture);
        expect(await simpleCoin.balanceOf(owner.address)).to.equal(10);
    });

    it("Should mint coins", async function() {
        const { simpleCoin, initialSupply, owner, account1 } = await loadFixture(deploySimpleCoinFixture);
        
        await simpleCoin.mint(account1.address, 65);
        expect(await simpleCoin.balanceOf(account1.address)).to.equal(65);

        await simpleCoin.mint(account1.address, 5);
        expect(await simpleCoin.balanceOf(account1.address)).to.equal(70);
    });

    it("Should transfer coins from owner to another account", async function() {
        const { simpleCoin, initialSupply, owner, account1 } = await loadFixture(deploySimpleCoinFixture);

        await simpleCoin.mint(account1.address, 6);
        await simpleCoin.transfer(account1.address, 2);

        expect(await simpleCoin.balanceOf(owner.address)).to.equal(8);
        expect(await simpleCoin.balanceOf(account1.address)).to.equal(8);
    });

    it("Should transfer coins from account1 to account2", async function() {
        const { simpleCoin, initialSupply, owner, account1, account2 } = await loadFixture(deploySimpleCoinFixture);

        await simpleCoin.mint(account1.address, 6);
        await simpleCoin.mint(account2.address, 7);

        await simpleCoin.transferFrom(account1.address, account2.address, 3);

        expect(await simpleCoin.balanceOf(account1.address)).to.equal(3);
        expect(await simpleCoin.balanceOf(account2.address)).to.equal(10);
    });
});