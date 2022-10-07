// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

// Görli USDC: 0x07865c6E87B9F70255377e024ace6630C1Eaa37F
// Görli USDC Faucet: https://usdcfaucet.com/

async function main() {
  const MembershipNFT = await hre.ethers.getContractFactory("PretzelDAO_Membership");
  const membershipNFT = await MembershipNFT.deploy(1, 2022, "0x07865c6E87B9F70255377e024ace6630C1Eaa37F", "0xb7a98Adc9254F54205e7ABD4Ad02984b97a10F17", "0xF0ADa8a71CB45a47D7BE26321054AEc88495f308");

  const contract = await membershipNFT.deployed();
  console.log(
    'Deployed MembershipNFT Contract ',
    contract.address
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
