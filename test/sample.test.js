require("@openzeppelin/test-helpers/configure")({
  provider: web3.currentProvider,
  singletons: { abstraction: "truffle" },
});

const { expect } = require("chai");
const {
  expectRevert,
  time,
  BN,
  constants,
} = require("@openzeppelin/test-helpers");
const { ZERO_ADDRESS } = constants;
const DAI = artifacts.require("./contracts/mocks/TestERC20Mock.sol");
const Vault = artifacts.require("./contracts/Vault.sol");

contract("Index", ([creator, alice, bob, chad, tom, noone]) => {
  beforeEach(async () => {
    dai = await DAI.new({ from: creator });
    vault = await Vault.new(dai.address, {
      from: creator,
    });

    await dai.mint(alice, (100000).toString(), { from: creator });
  });

  describe("Condition", function () {
    it("Should contracts be deployed", async () => {
      expect(dai.address).to.exist;
      expect(vault.address).to.exist;
    });
  });

  describe("deposit and withdraw", function () {
    it("succeeds with index", async function () {
      await dai.approve(vault.address, 10000, { from: alice });
      await vault.addValue("10000", alice, alice, {
        from: alice,
      });
      expect(await vault.valueAll()).to.be.bignumber.equal("10000");
      expect(await vault.totalAttributions()).to.be.bignumber.equal("10000");
      expect(await vault.valueOf(creator)).to.be.bignumber.equal("10000");
    });
  });
});
