import Web3 from "web3";
import { Contract } from "web3-eth-contract";
import {
  MARKETPLACE_CONTRACT_ADDRESS,
  TOKEN_CONTRACT_ADDRESS,
} from "./constants/contract-addresses";
import { marketplaceContractAbi } from "./contracts/Marketplace";
import { tokenContractAbi } from "./contracts/Token";

let selectedAccount: string;

let tokenContract: Contract;
let marketplaceContract: Contract;

let isMarketplaceInitialized: boolean = false;

export async function init(): Promise<void> {
  let provider = (window as any).ethereum;
  if (typeof provider !== "undefined") {
    // Metamask is installed

    await provider
      .request({ method: "eth_requestAccounts" })
      .then((accounts: any) => {
        selectedAccount = accounts[0];
        console.log(`Selected account is ${selectedAccount}.`);
      })
      .catch((error: any) => console.error(error));

    (window as any).ethereum.on("accountsChanged", function (accounts: any[]) {
      selectedAccount = accounts[0];
      console.log(`Selected account chaned to ${selectedAccount}.`);
    });
  }

  const web3 = new Web3(provider);

  tokenContract = new web3.eth.Contract(
    tokenContractAbi,
    TOKEN_CONTRACT_ADDRESS
  );

  marketplaceContract = new web3.eth.Contract(
    marketplaceContractAbi,
    MARKETPLACE_CONTRACT_ADDRESS
  );

  isMarketplaceInitialized = true;
}

export async function getCurrentFunds(): Promise<number> {
  if (!isMarketplaceInitialized) {
    await init();
  }

  return await tokenContract.methods.balanceOf(selectedAccount).call();
}
