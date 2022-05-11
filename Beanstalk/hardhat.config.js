require("@nomiclabs/hardhat-ethers");
module.exports = {
  solidity: "0.8.0",
  networks: {
    hardhat: {
      chainId: 1,
      forking: {
        url: "https://eth-mainnet.alchemyapi.io/v2/***",
        blockNumber: 14595309
      },
    }
  }
};

