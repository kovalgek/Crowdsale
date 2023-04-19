const { expect } = require("chai");
const { hre, ethers } = require("hardhat");
const { loadFixture, time } = require("@nomicfoundation/hardhat-network-helpers");

describe("SimpleCrowdsale", function() {

    async function deploySimpleCrowdsaleFixture() {

        const [owner, account1, account2] = await ethers.getSigners();
    
        const HOUR_IN_SECS = 60 * 60;
        const startTime = await time.latest() + HOUR_IN_SECS;
        const endTime = startTime + HOUR_IN_SECS;
        const weiTokenPrice = 10;
        const etherInvestmentObjective = 100;

        const SimpleCrowdsale = await ethers.getContractFactory("SimpleCrowdsale");
        const simpleCrowdsale = await SimpleCrowdsale.deploy(startTime, endTime, weiTokenPrice, etherInvestmentObjective);
    
        return { simpleCrowdsale, startTime, endTime, weiTokenPrice, etherInvestmentObjective, owner, account1, account2 };
    }

    it("Should revert when no crowdsale period", async function() {
        const { simpleCrowdsale, owner, account1} = await loadFixture(deploySimpleCrowdsaleFixture);

        let investment = ethers.utils.parseUnits("1", "ether");

        await expect(simpleCrowdsale.invest({ value: investment }))
        .to.be.revertedWith("Invalid investment");
    });


    it("Should rever when zero investment", async function() {
        const { simpleCrowdsale, owner, account1, startTime} = await loadFixture(deploySimpleCrowdsaleFixture);

        let investment = ethers.utils.parseUnits("0", "ether");

        await time.increaseTo(startTime);

        await expect(simpleCrowdsale.invest({ value: investment }))
        .to.be.revertedWith("Invalid investment");
    });

    it("Should emit proper event on investment", async function() {
        const { simpleCrowdsale, owner, account1, startTime} = await loadFixture(deploySimpleCrowdsaleFixture);

        let investment = ethers.utils.parseUnits("1", "ether");
        await time.increaseTo(startTime);

        await expect(simpleCrowdsale.invest({ value: investment }))
        .to.emit(simpleCrowdsale, "LogInvestment")
        .withArgs(owner.address, investment);
    });

    it("Shouldn't allow to finalize twice", async function() {
        const { simpleCrowdsale, owner, account1, endTime } = await loadFixture(deploySimpleCrowdsaleFixture);

        await time.increaseTo(endTime);
        await simpleCrowdsale.finalize();

        await expect(simpleCrowdsale.finalize())
        .to.be.revertedWith("Can't finalize twice");
    });

    it("Shouldn't allow to refund when contract isn't finalized", async function() {
        const { simpleCrowdsale } = await loadFixture(deploySimpleCrowdsaleFixture);

        await expect(simpleCrowdsale.refund())
        .to.be.revertedWith("Refunding isn't allowed yet");
    });

    it("Shouldn't allow to refund when account didn't invest", async function() {
        const { simpleCrowdsale, endTime } = await loadFixture(deploySimpleCrowdsaleFixture);

        await time.increaseTo(endTime);

        await simpleCrowdsale.finalize();

        await expect(simpleCrowdsale.refund())
        .to.be.revertedWith("Account didn't invest");
    });

    it("Should allow to refund when account invested", async function() {
        const { simpleCrowdsale, startTime, endTime, owner } = await loadFixture(deploySimpleCrowdsaleFixture);

        await time.increaseTo(startTime);

        let investment = ethers.utils.parseUnits("99", "ether");
        await simpleCrowdsale.invest({ value: investment });

        await time.increaseTo(endTime);

        await simpleCrowdsale.finalize();

        await expect(simpleCrowdsale.refund())
        .to.emit(simpleCrowdsale, "Refund")
        .withArgs(owner.address, investment);
    });    
});