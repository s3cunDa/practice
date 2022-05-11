require("@nomiclabs/hardhat-ethers");
module.exports = {
  solidity: "0.8.0",
  networks: {
    hardhat: {
      chainId: 56,
      forking: {
        url: "https://speedy-nodes-nyc.moralis.io/***/bsc/mainnet/archive",
        blockNumber: 15484858 
      },
    }
  }
};

