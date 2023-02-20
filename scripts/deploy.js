const hre = require("hardhat");

async function main() {
  const VanDuc = await hre.ethers.getContractFactory("VanDuc");
  const vanDuc = await VanDuc.deploy("VANDUC", "VDC");

  await vanDuc.deployed();
  console.log("Successfully deployed smart contract to: ", vanDuc.address);

  await vanDuc.mint("https://ipfs.io/ipfs/QmXtsv56C1L174Zb1zNKT6KfZhLL1RrKof4Df42h9sqyU7");

  console.log("NFT successfully minted");

}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
