const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();

  console.log("Deploying contracts with the account:", deployer.address);

  // Déployez le contrat NFTWithRoyalties avec les arguments nécessaires
  const NFTWithRoyalties = await hre.ethers.getContractFactory("NFTWithRoyalties");
  const nftWithRoyalties = await NFTWithRoyalties.deploy("MyNFTWithRoyalties", "MNFT");
  await nftWithRoyalties.deployed();
  console.log("NFTWithRoyalties deployed to:", nftWithRoyalties.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });




  