require('@nomiclabs/hardhat-waffle');
require('dotenv').config();

const { ALCHEMY_API_KEY, SEPOLIA_PRIVATE_KEY } = process.env;

module.exports = {
  solidity: {
    compilers: [
      {
        version: "0.8.24",
      },
      {
        version: "0.8.20",
      }
    ]
  },
  networks: {
    sepolia: {
      url: `https://eth-sepolia.g.alchemy.com/v2/${ALCHEMY_API_KEY}`,
      accounts: [`0x${SEPOLIA_PRIVATE_KEY}`],
    },
    matic: {
      url: `https://polygon-amoy.g.alchemy.com/v2/koGWWAPz_ocvtqGvcFe1LpjOAZZ3o1GP`,
      accounts: [`0x${SEPOLIA_PRIVATE_KEY}`]
    }
  },
};





