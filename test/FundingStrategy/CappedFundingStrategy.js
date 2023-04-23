const { expect } = require("chai");
const { loadFixture } = require("@nomicfoundation/hardhat-network-helpers");

describe("CappedFundingStrategy", function() {

    async function deployCappedFundingStrategyFixture() {

        const fundingCup = 351;

        const CappedFundingStrategy = await ethers.getContractFactory("CappedFundingStrategy");
        const cappedFundingStrategy = await CappedFundingStrategy.deploy(fundingCup);
    
        return { cappedFundingStrategy, fundingCup };
      }

    it("Should check investment limit", async function() {
        const { cappedFundingStrategy } = await loadFixture(deployCappedFundingStrategyFixture);

        expect(await cappedFundingStrategy.isFullInvestmentWithinLimit(12, 42)).to.be.true;
        expect(await cappedFundingStrategy.isFullInvestmentWithinLimit(270, 200)).to.be.false;
    });
});