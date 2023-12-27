require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.18",
  settings: {
    optimizer: {
        enabled: true,
        runs: 100
    }
  },
  networks: {
    'truffle-dashboard': {
      url: "http://localhost:24012/rpc"
    }
  }
};
