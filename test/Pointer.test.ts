import { ethers, waffle } from "hardhat";
import { expect } from "chai";

import PointerArtifact from "../artifacts/contracts/Pointer.sol/Pointer.json";
import type { Pointer } from "../typechain/Pointer";

const { deployContract } = waffle;

describe("Pointer Address", () => {
  let pointer: Pointer;
  const INITIAL_ADDRESS = "0x9907a0cf64ec9fbf6ed8fd4971090de88222a9ac";

  beforeEach(async () => {
    const signers = await ethers.getSigners();

    pointer = (await deployContract(signers[0], PointerArtifact, [
      INITIAL_ADDRESS,
    ])) as Pointer;

    expect(await pointer.addr()).to.be.hexEqual(INITIAL_ADDRESS);

    pointer.on("AddressTransferred", (index, previousAddress, newAddress) => {
      console.log(index, previousAddress, "=>", newAddress);
    });
  });

  context("new Address", async () => {
    it("has given data", async () => {
      const TEST_ADDRESS = "0x71C7656EC7ab88b098defB751B7401B5f6d8976F";

      await pointer.transferAddress(TEST_ADDRESS, "0.0.2");

      expect(await pointer.addr()).to.be.hexEqual(TEST_ADDRESS);
    });
  });
});
