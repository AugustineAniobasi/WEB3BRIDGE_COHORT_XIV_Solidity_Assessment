import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "@nomicfoundation/hardhat-ignition-ethers";
import * as dotenv from "dotenv";

dotenv.config();

const { LISK_SEPOLIA_URL, ARC_TESTNET_URL, PRIVATE_KEY } = process.env;

const config: HardhatUserConfig = {
  solidity: "0.8.28",
  networks: {
    LiskSepolia: {
      url: LISK_SEPOLIA_URL || "",
      chainId: 4202,
      accounts: PRIVATE_KEY ? [PRIVATE_KEY] : []
    },
    arcTestnet: {
      url: ARC_TESTNET_URL || "",
      chainId:5042002,
      accounts: PRIVATE_KEY ? [PRIVATE_KEY] : []
    },
  },
};

export default config;
