require("@nomiclabs/hardhat-waffle");
require("dotenv").config();

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: {
    compilers: [
      {
        version: "0.8.20",
      },
      {
        version: "0.8.0",
      },
      {
        version: "0.6.12",
      },
    ],
  },
  networks: {
    sepolia: {
      url: `https://sepolia.infura.io/v3/${process.env.INFURA_API_KEY}`,
      accounts: [
        `${process.env.PRIVATE_KEY_ACC_1}`,
        `${process.env.PRIVATE_KEY_ACC_2}`,
      ],
    },
    binanceTestnet: {
      url: "https://data-seed-prebsc-1-s1.binance.org:8545",
      accounts: [
        `${process.env.PRIVATE_KEY_ACC_1}` , 
        `${process.env.PRIVATE_KEY_ACC_2}`
      ],
    },
  },
  paths: {
    artifacts: "./src/artifacts",
  },
};
