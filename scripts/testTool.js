// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

async function main() {
  // const IERC20 = await hre.ethers.getContractFactory("WENERC20");
  // const WEN = await IERC20.attach("0x20143C45c2Ce7984799079F256d8a68A918EeEe6");
  // await WEN.approve("0x153ce546c0cddce1288dffc37ff95a67c922c63e", ethers.parseEther("1000"));

  const SwapAndCloseTool = await hre.ethers.getContractFactory("SwapAndCloseTool");
  const tool = await SwapAndCloseTool.attach("0x153ce546c0cddce1288dffc37ff95a67c922c63e");
  await tool.swapAndCloseTrove({value: ethers.parseEther("10")});

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
