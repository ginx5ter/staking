require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-ethers");

module.exports = {
  networks: {
    mainnet: {
      url: "https://eth-mainnet.g.alchemy.com/v2/QW2v-ziGMD_a3cKJna_tB7_g0YdgaK-n",
      accounts: ["8b625a9f134b8842cfae6aa98c1d2d576abe3f7d1922fa1939f3d861267514f9"],
    },
  },
  solidity: {
    version: "0.8.20",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
};
