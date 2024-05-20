const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);

  // Déployez le contrat NFTMarketplace.sol
  const NFTWithRoyalties= await hre.ethers.getContractFactory("NFTWithRoyalties");
  const nftwithroyalties = await NFTWithRoyalties.deploy();
  await nftwithroyalties.deployed();
  console.log("NFTMarketplace deployed to:", nftwithroyalties.address);
  
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });




  