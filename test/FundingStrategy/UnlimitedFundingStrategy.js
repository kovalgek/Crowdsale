const { expect } = require("chai");
const { loadFixture } = require("@nomicfoundation/hardhat-network-helpers");

describe("UnlimitedFundingStrategy", function() {

    async function deployUnlimitedFundingStrategyFixture() {

        const UnlimitedFundingStrategy = await ethers.getContractFactory("UnlimitedFundingStrategy");
        const unlimitedFundingStrategy = await UnlimitedFundingStrategy.deploy();
    
        return { unlimitedFundingStrategy };
      }

    it("Should check investment limit", async function() {
        const { unlimitedFundingStrategy} = await loadFixture(deployUnlimitedFundingStrategyFixture);

        expect(await unlimitedFundingStrategy.isFullInvestmentWithinLimit(12, 42)).to.be.true;
        expect(await unlimitedFundingStrategy.isFullInvestmentWithinLimit(270, 200)).to.be.true;
    });
});