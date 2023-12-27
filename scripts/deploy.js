// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

async function main() {
  const SwapAndCloseTool = await hre.ethers.getContractFactory("SwapAndCloseTool");
  const tool = await SwapAndCloseTool.deploy('0x51729FC7f777b29ffCd40fD4ccC699BC2e023826', '0x147cdae2bf7e809b9789ad0765899c06b361c5ce');

  await tool.deployed();
  console.log("SwapAndCloseTool deployed at: ", tool.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
