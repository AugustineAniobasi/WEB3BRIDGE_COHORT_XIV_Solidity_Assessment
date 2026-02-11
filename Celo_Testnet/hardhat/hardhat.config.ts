import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import * as dotenv from "dotenv";

dotenv.config();

const PRIVATE_KEY = process.env.PRIVATE_KEY || "";
const CELO_SEPOLIA_RPC_URL =
  process.env.CELO_SEPOLIA_RPC_URL || "https://forno.celo-sepolia.celo-testnet.org"; 

const config: HardhatUserConfig = {
  solidity: "0.8.30", 

  networks: {
    celoSepolia: {
      url: CELO_SEPOLIA_RPC_URL,
      chainId: 11142220, 
      accounts: PRIVATE_KEY ? [PRIVATE_KEY] : [],
    },
  },
};

export default config;
