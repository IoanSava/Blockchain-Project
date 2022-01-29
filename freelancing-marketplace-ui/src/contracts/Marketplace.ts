import { AbiItem } from "web3-utils";

export const marketplaceContractAbi: AbiItem[] = [
  {
    inputs: [
      {
        internalType: "address",
        name: "_managerAddress",
        type: "address",
      },
      {
        internalType: "address",
        name: "_firstContributorAddress",
        type: "address",
      },
      {
        internalType: "address",
        name: "_secondContributorAddress",
        type: "address",
      },
      {
        internalType: "address",
        name: "_firstAssessorAddress",
        type: "address",
      },
      {
        internalType: "address",
        name: "_secondAssessorAddress",
        type: "address",
      },
      {
        internalType: "address",
        name: "_firstFreelancerAddress",
        type: "address",
      },
      {
        internalType: "address",
        name: "_secondFreelancerAddress",
        type: "address",
      },
      {
        internalType: "address",
        name: "_thirdFreelancerAddress",
        type: "address",
      },
    ],
    stateMutability: "nonpayable",
    type: "constructor",
  },
  {
    anonymous: false,
    inputs: [
      {
        indexed: false,
        internalType: "address",
        name: "tokenAddress",
        type: "address",
      },
    ],
    name: "TokenCreated",
    type: "event",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "_taskId",
        type: "uint256",
      },
    ],
    name: "acceptTaskByAssessor",
    outputs: [
      {
        internalType: "string",
        name: "",
        type: "string",
      },
    ],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "_taskId",
        type: "uint256",
      },
    ],
    name: "acceptTaskByManager",
    outputs: [
      {
        internalType: "string",
        name: "",
        type: "string",
      },
    ],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "_taskId",
        type: "uint256",
      },
    ],
    name: "applyForTask",
    outputs: [
      {
        internalType: "string",
        name: "",
        type: "string",
      },
    ],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "_assessorAddress",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "_taskId",
        type: "uint256",
      },
    ],
    name: "assignAssessorForTask",
    outputs: [
      {
        internalType: "string",
        name: "",
        type: "string",
      },
    ],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "_taskId",
        type: "uint256",
      },
    ],
    name: "cancelTask",
    outputs: [
      {
        internalType: "string",
        name: "",
        type: "string",
      },
    ],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "string",
        name: "_description",
        type: "string",
      },
      {
        internalType: "uint256",
        name: "_freelancerReward",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "_assessorReward",
        type: "uint256",
      },
      {
        internalType: "string",
        name: "_category",
        type: "string",
      },
    ],
    name: "createTask",
    outputs: [
      {
        internalType: "string",
        name: "",
        type: "string",
      },
    ],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "_taskId",
        type: "uint256",
      },
    ],
    name: "declineTaskByAssessor",
    outputs: [
      {
        internalType: "string",
        name: "",
        type: "string",
      },
    ],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "_taskId",
        type: "uint256",
      },
    ],
    name: "declineTaskByManager",
    outputs: [
      {
        internalType: "string",
        name: "",
        type: "string",
      },
    ],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "_taskId",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "_tokenAmount",
        type: "uint256",
      },
    ],
    name: "financeTask",
    outputs: [
      {
        internalType: "string",
        name: "",
        type: "string",
      },
    ],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "_taskId",
        type: "uint256",
      },
    ],
    name: "getApplicationsForTask",
    outputs: [
      {
        components: [
          {
            internalType: "address",
            name: "freelancerAddress",
            type: "address",
          },
          {
            internalType: "string",
            name: "name",
            type: "string",
          },
          {
            internalType: "string",
            name: "category",
            type: "string",
          },
          {
            internalType: "uint256",
            name: "reputation",
            type: "uint256",
          },
        ],
        internalType: "struct Marketplace.freelancer[]",
        name: "",
        type: "tuple[]",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "getAssessors",
    outputs: [
      {
        components: [
          {
            internalType: "string",
            name: "name",
            type: "string",
          },
          {
            internalType: "string",
            name: "category",
            type: "string",
          },
          {
            internalType: "address",
            name: "assessorAddress",
            type: "address",
          },
        ],
        internalType: "struct Marketplace.assessor[]",
        name: "",
        type: "tuple[]",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "_taskId",
        type: "uint256",
      },
    ],
    name: "getContributionsForTask",
    outputs: [
      {
        components: [
          {
            internalType: "address",
            name: "contributorAddress",
            type: "address",
          },
          {
            internalType: "uint256",
            name: "contribution",
            type: "uint256",
          },
        ],
        internalType: "struct Marketplace.contributorContribution[]",
        name: "",
        type: "tuple[]",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "_contributorAddress",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "_taskId",
        type: "uint256",
      },
    ],
    name: "getContributorContributionForTask",
    outputs: [
      {
        internalType: "uint256",
        name: "",
        type: "uint256",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "getDoneTasks",
    outputs: [
      {
        components: [
          {
            internalType: "uint256",
            name: "id",
            type: "uint256",
          },
          {
            internalType: "string",
            name: "description",
            type: "string",
          },
          {
            internalType: "uint256",
            name: "freelancerReward",
            type: "uint256",
          },
          {
            internalType: "uint256",
            name: "assessorReward",
            type: "uint256",
          },
          {
            internalType: "string",
            name: "category",
            type: "string",
          },
          {
            internalType: "address",
            name: "managerAddress",
            type: "address",
          },
          {
            internalType: "address",
            name: "assessorAddress",
            type: "address",
          },
          {
            internalType: "address",
            name: "freelancerAddress",
            type: "address",
          },
          {
            internalType: "uint256",
            name: "currentFunds",
            type: "uint256",
          },
          {
            internalType: "enum Marketplace.TaskState",
            name: "state",
            type: "uint8",
          },
        ],
        internalType: "struct Marketplace.task[]",
        name: "",
        type: "tuple[]",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "getFinancedTasks",
    outputs: [
      {
        components: [
          {
            internalType: "uint256",
            name: "id",
            type: "uint256",
          },
          {
            internalType: "string",
            name: "description",
            type: "string",
          },
          {
            internalType: "uint256",
            name: "freelancerReward",
            type: "uint256",
          },
          {
            internalType: "uint256",
            name: "assessorReward",
            type: "uint256",
          },
          {
            internalType: "string",
            name: "category",
            type: "string",
          },
          {
            internalType: "address",
            name: "managerAddress",
            type: "address",
          },
          {
            internalType: "address",
            name: "assessorAddress",
            type: "address",
          },
          {
            internalType: "address",
            name: "freelancerAddress",
            type: "address",
          },
          {
            internalType: "uint256",
            name: "currentFunds",
            type: "uint256",
          },
          {
            internalType: "enum Marketplace.TaskState",
            name: "state",
            type: "uint8",
          },
        ],
        internalType: "struct Marketplace.task[]",
        name: "",
        type: "tuple[]",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "getFinancingTasks",
    outputs: [
      {
        components: [
          {
            internalType: "uint256",
            name: "id",
            type: "uint256",
          },
          {
            internalType: "string",
            name: "description",
            type: "string",
          },
          {
            internalType: "uint256",
            name: "freelancerReward",
            type: "uint256",
          },
          {
            internalType: "uint256",
            name: "assessorReward",
            type: "uint256",
          },
          {
            internalType: "string",
            name: "category",
            type: "string",
          },
          {
            internalType: "address",
            name: "managerAddress",
            type: "address",
          },
          {
            internalType: "address",
            name: "assessorAddress",
            type: "address",
          },
          {
            internalType: "address",
            name: "freelancerAddress",
            type: "address",
          },
          {
            internalType: "uint256",
            name: "currentFunds",
            type: "uint256",
          },
          {
            internalType: "enum Marketplace.TaskState",
            name: "state",
            type: "uint8",
          },
        ],
        internalType: "struct Marketplace.task[]",
        name: "",
        type: "tuple[]",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "_address",
        type: "address",
      },
    ],
    name: "getFreelancerByAddress",
    outputs: [
      {
        components: [
          {
            internalType: "address",
            name: "freelancerAddress",
            type: "address",
          },
          {
            internalType: "string",
            name: "name",
            type: "string",
          },
          {
            internalType: "string",
            name: "category",
            type: "string",
          },
          {
            internalType: "uint256",
            name: "reputation",
            type: "uint256",
          },
        ],
        internalType: "struct Marketplace.freelancer",
        name: "",
        type: "tuple",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "getNeedsArbitrationTasks",
    outputs: [
      {
        components: [
          {
            internalType: "uint256",
            name: "id",
            type: "uint256",
          },
          {
            internalType: "string",
            name: "description",
            type: "string",
          },
          {
            internalType: "uint256",
            name: "freelancerReward",
            type: "uint256",
          },
          {
            internalType: "uint256",
            name: "assessorReward",
            type: "uint256",
          },
          {
            internalType: "string",
            name: "category",
            type: "string",
          },
          {
            internalType: "address",
            name: "managerAddress",
            type: "address",
          },
          {
            internalType: "address",
            name: "assessorAddress",
            type: "address",
          },
          {
            internalType: "address",
            name: "freelancerAddress",
            type: "address",
          },
          {
            internalType: "uint256",
            name: "currentFunds",
            type: "uint256",
          },
          {
            internalType: "enum Marketplace.TaskState",
            name: "state",
            type: "uint8",
          },
        ],
        internalType: "struct Marketplace.task[]",
        name: "",
        type: "tuple[]",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "getReadyTasks",
    outputs: [
      {
        components: [
          {
            internalType: "uint256",
            name: "id",
            type: "uint256",
          },
          {
            internalType: "string",
            name: "description",
            type: "string",
          },
          {
            internalType: "uint256",
            name: "freelancerReward",
            type: "uint256",
          },
          {
            internalType: "uint256",
            name: "assessorReward",
            type: "uint256",
          },
          {
            internalType: "string",
            name: "category",
            type: "string",
          },
          {
            internalType: "address",
            name: "managerAddress",
            type: "address",
          },
          {
            internalType: "address",
            name: "assessorAddress",
            type: "address",
          },
          {
            internalType: "address",
            name: "freelancerAddress",
            type: "address",
          },
          {
            internalType: "uint256",
            name: "currentFunds",
            type: "uint256",
          },
          {
            internalType: "enum Marketplace.TaskState",
            name: "state",
            type: "uint8",
          },
        ],
        internalType: "struct Marketplace.task[]",
        name: "",
        type: "tuple[]",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "_address",
        type: "address",
      },
    ],
    name: "getRoleByAddress",
    outputs: [
      {
        internalType: "string",
        name: "",
        type: "string",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "_taskId",
        type: "uint256",
      },
    ],
    name: "getTaskById",
    outputs: [
      {
        components: [
          {
            internalType: "uint256",
            name: "id",
            type: "uint256",
          },
          {
            internalType: "string",
            name: "description",
            type: "string",
          },
          {
            internalType: "uint256",
            name: "freelancerReward",
            type: "uint256",
          },
          {
            internalType: "uint256",
            name: "assessorReward",
            type: "uint256",
          },
          {
            internalType: "string",
            name: "category",
            type: "string",
          },
          {
            internalType: "address",
            name: "managerAddress",
            type: "address",
          },
          {
            internalType: "address",
            name: "assessorAddress",
            type: "address",
          },
          {
            internalType: "address",
            name: "freelancerAddress",
            type: "address",
          },
          {
            internalType: "uint256",
            name: "currentFunds",
            type: "uint256",
          },
          {
            internalType: "enum Marketplace.TaskState",
            name: "state",
            type: "uint8",
          },
        ],
        internalType: "struct Marketplace.task",
        name: "",
        type: "tuple",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "getTasks",
    outputs: [
      {
        components: [
          {
            internalType: "uint256",
            name: "id",
            type: "uint256",
          },
          {
            internalType: "string",
            name: "description",
            type: "string",
          },
          {
            internalType: "uint256",
            name: "freelancerReward",
            type: "uint256",
          },
          {
            internalType: "uint256",
            name: "assessorReward",
            type: "uint256",
          },
          {
            internalType: "string",
            name: "category",
            type: "string",
          },
          {
            internalType: "address",
            name: "managerAddress",
            type: "address",
          },
          {
            internalType: "address",
            name: "assessorAddress",
            type: "address",
          },
          {
            internalType: "address",
            name: "freelancerAddress",
            type: "address",
          },
          {
            internalType: "uint256",
            name: "currentFunds",
            type: "uint256",
          },
          {
            internalType: "enum Marketplace.TaskState",
            name: "state",
            type: "uint8",
          },
        ],
        internalType: "struct Marketplace.task[]",
        name: "",
        type: "tuple[]",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "getTasksOfFreelancer",
    outputs: [
      {
        components: [
          {
            internalType: "uint256",
            name: "id",
            type: "uint256",
          },
          {
            internalType: "string",
            name: "description",
            type: "string",
          },
          {
            internalType: "uint256",
            name: "freelancerReward",
            type: "uint256",
          },
          {
            internalType: "uint256",
            name: "assessorReward",
            type: "uint256",
          },
          {
            internalType: "string",
            name: "category",
            type: "string",
          },
          {
            internalType: "address",
            name: "managerAddress",
            type: "address",
          },
          {
            internalType: "address",
            name: "assessorAddress",
            type: "address",
          },
          {
            internalType: "address",
            name: "freelancerAddress",
            type: "address",
          },
          {
            internalType: "uint256",
            name: "currentFunds",
            type: "uint256",
          },
          {
            internalType: "enum Marketplace.TaskState",
            name: "state",
            type: "uint8",
          },
        ],
        internalType: "struct Marketplace.task[]",
        name: "",
        type: "tuple[]",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [],
    name: "getWorkInProgressTasks",
    outputs: [
      {
        components: [
          {
            internalType: "uint256",
            name: "id",
            type: "uint256",
          },
          {
            internalType: "string",
            name: "description",
            type: "string",
          },
          {
            internalType: "uint256",
            name: "freelancerReward",
            type: "uint256",
          },
          {
            internalType: "uint256",
            name: "assessorReward",
            type: "uint256",
          },
          {
            internalType: "string",
            name: "category",
            type: "string",
          },
          {
            internalType: "address",
            name: "managerAddress",
            type: "address",
          },
          {
            internalType: "address",
            name: "assessorAddress",
            type: "address",
          },
          {
            internalType: "address",
            name: "freelancerAddress",
            type: "address",
          },
          {
            internalType: "uint256",
            name: "currentFunds",
            type: "uint256",
          },
          {
            internalType: "enum Marketplace.TaskState",
            name: "state",
            type: "uint8",
          },
        ],
        internalType: "struct Marketplace.task[]",
        name: "",
        type: "tuple[]",
      },
    ],
    stateMutability: "view",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "_taskId",
        type: "uint256",
      },
    ],
    name: "markTaskAsDone",
    outputs: [
      {
        internalType: "string",
        name: "",
        type: "string",
      },
    ],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "address",
        name: "_freelancerAddress",
        type: "address",
      },
      {
        internalType: "uint256",
        name: "_taskId",
        type: "uint256",
      },
    ],
    name: "selectFreelancerForTask",
    outputs: [
      {
        internalType: "string",
        name: "",
        type: "string",
      },
    ],
    stateMutability: "nonpayable",
    type: "function",
  },
  {
    inputs: [
      {
        internalType: "uint256",
        name: "_taskId",
        type: "uint256",
      },
      {
        internalType: "uint256",
        name: "_tokenAmount",
        type: "uint256",
      },
    ],
    name: "withdrawFunds",
    outputs: [
      {
        internalType: "string",
        name: "",
        type: "string",
      },
    ],
    stateMutability: "nonpayable",
    type: "function",
  },
];
