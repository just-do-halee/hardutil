import { waffle } from "hardhat";
import { expect } from "chai";

import PointerArtifact from "../artifacts/contracts/Pointer.sol/Pointer.json";
import { Pointer } from "../typechain/Pointer";

const { deployContract } = waffle;

describe("Pointer Address", () => {
  let pointer: Pointer;
  const INITIAL_ADDRESS = "0x9907a0cf64ec9fbf6ed8fd4971090de88222a9ac";

  const provider = waffle.provider;
  const [admin] = provider.getWallets();

  beforeEach(async () => {
    pointer = (await deployContract(admin, PointerArtifact, [
      INITIAL_ADDRESS,
    ])) as Pointer;

    pointer.on("AddressTransferred", (previousAddress, newAddress) => {
      console.log(previousAddress, "=>", newAddress);
    });
  });

  context("new Address", async () => {
    it("has given data", async () => {
      expect(await pointer.addr()).to.be.hexEqual(INITIAL_ADDRESS);

      const TEST_ADDRESS = "0x71C7656EC7ab88b098defB751B7401B5f6d8976F";

      await pointer.transferAddress(TEST_ADDRESS);

      expect(await pointer.addr()).to.be.hexEqual(TEST_ADDRESS);
    });
  });
});
