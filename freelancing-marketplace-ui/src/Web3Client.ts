import Web3 from "web3";
import { Contract } from "web3-eth-contract";
import {
  MARKETPLACE_CONTRACT_ADDRESS,
  TOKEN_CONTRACT_ADDRESS,
} from "./constants/contract-addresses";
import { marketplaceContractAbi } from "./contracts/Marketplace";
import { tokenContractAbi } from "./contracts/Token";
import { Assessor } from "./models/Assessor";
import { Freelancer } from "./models/Freelancer";
import { Task } from "./models/Task";

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

export async function createNewTask(
  description: string,
  freelancerReward: number,
  assessorReward: number,
  category: string
): Promise<string> {
  if (!isMarketplaceInitialized) {
    await init();
  }

  console.log(
    `Create task: [${description}, ${freelancerReward}, ${assessorReward}, ${category}].`
  );

  return await marketplaceContract.methods
    .createTask(description, freelancerReward, assessorReward, category)
    .send({
      from: selectedAccount,
    });
}

export async function getTasks(): Promise<Task[]> {
  if (!isMarketplaceInitialized) {
    await init();
  }

  return await marketplaceContract.methods.getTasks().call({
    from: selectedAccount,
  });
}

export async function getAssessors(): Promise<Assessor[]> {
  if (!isMarketplaceInitialized) {
    await init();
  }

  return await marketplaceContract.methods.getAssessors().call({
    from: selectedAccount,
  });
}

export async function getRoleByAddress(): Promise<string> {
  if (!isMarketplaceInitialized) {
    await init();
  }

  return await marketplaceContract.methods
    .getRoleByAddress(selectedAccount)
    .call();
}

export function getAddress(): string {
  return selectedAccount;
}

export async function getTaskById(taskId: number): Promise<Task> {
  if (!isMarketplaceInitialized) {
    await init();
  }

  return await marketplaceContract.methods.getTaskById(taskId).call();
}

export async function cancelTask(taskId: number): Promise<string> {
  if (!isMarketplaceInitialized) {
    await init();
  }

  return await marketplaceContract.methods.cancelTask(taskId).send({
    from: selectedAccount,
  });
}

export async function getContributorContributionForTask(
  taskId: number
): Promise<number> {
  if (!isMarketplaceInitialized) {
    await init();
  }

  return await marketplaceContract.methods
    .getContributorContributionForTask(selectedAccount, taskId)
    .call({
      from: selectedAccount,
    });
}

export async function increaseAllowance(addedValue: number): Promise<void> {
  await tokenContract.methods
    .increaseAllowance(MARKETPLACE_CONTRACT_ADDRESS, addedValue)
    .send({
      from: selectedAccount,
    });
}

export async function financeTask(
  taskId: number,
  contribution: number
): Promise<string> {
  if (!isMarketplaceInitialized) {
    await init();
  }

  await increaseAllowance(contribution);

  return await marketplaceContract.methods
    .financeTask(taskId, contribution)
    .send({
      from: selectedAccount,
    });
}

export async function withdrawFunds(
  taskId: number,
  fundsToWithdraw: number
): Promise<string> {
  if (!isMarketplaceInitialized) {
    await init();
  }

  return await marketplaceContract.methods
    .withdrawFunds(taskId, fundsToWithdraw)
    .send({
      from: selectedAccount,
    });
}

export async function assignAssessorForTask(
  assessorAddress: string,
  taskId: number
): Promise<string> {
  if (!isMarketplaceInitialized) {
    await init();
  }

  return await marketplaceContract.methods
    .assignAssessorForTask(assessorAddress, taskId)
    .send({
      from: selectedAccount,
    });
}

export async function applyForTask(
  taskId: number,
  assessorReward: number
): Promise<string> {
  if (!isMarketplaceInitialized) {
    await init();
  }

  await increaseAllowance(assessorReward);

  return await marketplaceContract.methods.applyForTask(taskId).send({
    from: selectedAccount,
  });
}

export async function getFreelancerByAddress(): Promise<Freelancer> {
  if (!isMarketplaceInitialized) {
    await init();
  }

  return await marketplaceContract.methods
    .getFreelancerByAddress(selectedAccount)
    .call();
}

export async function getApplicationsForTask(
  taskId: number
): Promise<Freelancer[]> {
  if (!isMarketplaceInitialized) {
    await init();
  }

  return await marketplaceContract.methods
    .getApplicationsForTask(taskId)
    .call();
}

export async function selectFreelancerForTask(
  freelancerAddress: string,
  taskId: number
): Promise<string> {
  if (!isMarketplaceInitialized) {
    await init();
  }

  return await marketplaceContract.methods
    .selectFreelancerForTask(freelancerAddress, taskId)
    .send({
      from: selectedAccount,
    });
}

export async function markTaskAsDone(taskId: number): Promise<string> {
  if (!isMarketplaceInitialized) {
    await init();
  }

  return await marketplaceContract.methods.markTaskAsDone(taskId).send({
    from: selectedAccount,
  });
}

export async function acceptTaskByManager(taskId: number): Promise<string> {
  if (!isMarketplaceInitialized) {
    await init();
  }

  return await marketplaceContract.methods.acceptTaskByManager(taskId).send({
    from: selectedAccount,
  });
}

export async function declineTaskByManager(taskId: number): Promise<string> {
  if (!isMarketplaceInitialized) {
    await init();
  }

  return await marketplaceContract.methods.declineTaskByManager(taskId).send({
    from: selectedAccount,
  });
}

export async function acceptTaskByAssessor(taskId: number): Promise<string> {
  if (!isMarketplaceInitialized) {
    await init();
  }

  return await marketplaceContract.methods.acceptTaskByAssessor(taskId).send({
    from: selectedAccount,
  });
}

export async function declineTaskByAssessor(taskId: number): Promise<string> {
  if (!isMarketplaceInitialized) {
    await init();
  }

  return await marketplaceContract.methods.declineTaskByAssessor(taskId).send({
    from: selectedAccount,
  });
}
