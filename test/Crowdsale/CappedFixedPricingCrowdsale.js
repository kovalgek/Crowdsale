const { expect } = require("chai");
const { hre, ethers } = require("hardhat");
const { loadFixture, time } = require("@nomicfoundation/hardhat-network-helpers");

describe("CappedFixedPricingCrowdsale", function() {

    async function deployCappedFixedPricingCrowdsaleFixture() {

        const [owner, account1, account2] = await ethers.getSigners();
    
        const HOUR_IN_SECS = 60 * 60;
        const startTime = await time.latest() + HOUR_IN_SECS;
        const endTime = startTime + HOUR_IN_SECS;
        const weiTokenPrice = 10;
        const etherInvestmentObjective = 10;

        const CappedFixedPricingCrowdsale = await ethers.getContractFactory("CappedFixedPricingCrowdsale");
        const cappedFixedPricingCrowdsale = await CappedFixedPricingCrowdsale.deploy(startTime, endTime, weiTokenPrice, etherInvestmentObjective);
    
        return { cappedFixedPricingCrowdsale, startTime, endTime, weiTokenPrice, etherInvestmentObjective, owner, account1, account2 };
    }

    it("Should revert when no crowdsale period", async function() {
        const { cappedFixedPricingCrowdsale } = await loadFixture(deployCappedFixedPricingCrowdsaleFixture);

        let investment = ethers.utils.parseUnits("1", "ether");

        await expect(cappedFixedPricingCrowdsale.invest({ value: investment }))
        .to.be.revertedWith("Invalid investment");
    });


    it("Should rever when zero investment", async function() {
        const { cappedFixedPricingCrowdsale, startTime} = await loadFixture(deployCappedFixedPricingCrowdsaleFixture);

        let investment = ethers.utils.parseUnits("0", "ether");

        await time.increaseTo(startTime);

        await expect(cappedFixedPricingCrowdsale.invest({ value: investment }))
        .to.be.revertedWith("Invalid investment");
    });


    it("Should rever when enough investment", async function() {
        const { cappedFixedPricingCrowdsale, startTime} = await loadFixture(deployCappedFixedPricingCrowdsaleFixture);

        let investment = ethers.utils.parseUnits("50", "ether");

        await time.increaseTo(startTime);

        await expect(cappedFixedPricingCrowdsale.invest({ value: investment }))
        .to.be.revertedWith("Invalid investment");
    });

    it("Should emit proper event on investment", async function() {
        const { cappedFixedPricingCrowdsale, owner, startTime} = await loadFixture(deployCappedFixedPricingCrowdsaleFixture);

        let investment = ethers.utils.parseUnits("1", "ether");
        await time.increaseTo(startTime);

        await expect(cappedFixedPricingCrowdsale.invest({ value: investment }))
        .to.emit(cappedFixedPricingCrowdsale, "LogInvestment")
        .withArgs(owner.address, investment);
    });

    it("Shouldn't allow to finalize twice", async function() {
        const { cappedFixedPricingCrowdsale, endTime } = await loadFixture(deployCappedFixedPricingCrowdsaleFixture);

        await time.increaseTo(endTime);
        await cappedFixedPricingCrowdsale.finalize();

        await expect(cappedFixedPricingCrowdsale.finalize())
        .to.be.revertedWith("Can't finalize twice");
    });

    it("Shouldn allow to release", async function() {
        const { cappedFixedPricingCrowdsale, startTime, endTime } = await loadFixture(deployCappedFixedPricingCrowdsaleFixture);

        await time.increaseTo(startTime);

        let investment = ethers.utils.parseUnits("11", "ether");
        await cappedFixedPricingCrowdsale.invest({ value: investment });

        await time.increaseTo(endTime);

        await cappedFixedPricingCrowdsale.finalize();

        await expect(cappedFixedPricingCrowdsale.finalize())
        .to.be.revertedWith("Can't finalize twice");

        await expect(cappedFixedPricingCrowdsale.refund())
        .to.be.revertedWith("Refunding isn't allowed yet");
    });

    it("Shouldn't allow to refund when contract isn't finalized", async function() {
        const { cappedFixedPricingCrowdsale } = await loadFixture(deployCappedFixedPricingCrowdsaleFixture);

        await expect(cappedFixedPricingCrowdsale.refund())
        .to.be.revertedWith("Refunding isn't allowed yet");
    });

    it("Shouldn't allow to refund when account didn't invest", async function() {
        const { cappedFixedPricingCrowdsale, endTime } = await loadFixture(deployCappedFixedPricingCrowdsaleFixture);

        await time.increaseTo(endTime);

        await cappedFixedPricingCrowdsale.finalize();

        await expect(cappedFixedPricingCrowdsale.refund())
        .to.be.revertedWith("Account didn't invest");
    });

    it("Should allow to refund when account invested", async function() {
        const { cappedFixedPricingCrowdsale, startTime, endTime, owner } = await loadFixture(deployCappedFixedPricingCrowdsaleFixture);

        await time.increaseTo(startTime);

        let investment = ethers.utils.parseUnits("9", "ether");
        await cappedFixedPricingCrowdsale.invest({ value: investment });

        await time.increaseTo(endTime);

        await cappedFixedPricingCrowdsale.finalize();

        await expect(cappedFixedPricingCrowdsale.refund())
        .to.emit(cappedFixedPricingCrowdsale, "Refund")
        .withArgs(owner.address, investment);
    });
});