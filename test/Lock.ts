import { time, loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
import { ethers } from "hardhat";

describe("NftGame", function () {
  // We define a fixture to reuse the same setup in every test.
  // We use loadFixture to run this setup once, snapshot that state,
  // and reset Hardhat Network to that snapshopt in every test.

  describe("Deployment", function () {
    it("Should set the right unlockTime", async function () {
      const [owner, otherAccount] = await ethers.getSigners();

      const NftGame = await ethers.getContractFactory("NftGame");
      const nftGame = await NftGame.deploy("test", "tst", 10);

      await nftGame.createCharacter("test");

      await expect(await nftGame.getCharacterLevel(0)).to.equal(1);
    });
  });
});
