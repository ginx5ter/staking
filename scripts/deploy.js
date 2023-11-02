const hre = require("hardhat");

async function main() {
  const deployerAddress = "0x76cb413251533b0AB0794e2Def09d15A423e47Fb";

  console.log("Deploying contract with address:", deployerAddress);

  const [deployer] = await ethers.getSigners();

  const Staking = await hre.ethers.getContractFactory("Staking");
  const stakingContract = await Staking.deploy(
    3600,
    1000000,
    "0x30176cecb6dbf0869d59493142925a0287b12216"
  );
  await stakingContract.deployed();

  console.log("Contract deployed to address:", stakingContract.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
