export interface Task {
  id: number;
  description: string;
  freelancerReward: number;
  assessorReward: number;
  category: string;
  managerAddress: string;
  assessorAddress: string;
  freelancerAddress: string;
  currentFunds: number;
  state: TaskState;
}

export enum TaskState {
  Financing,
  Financed,
  Canceled,
  Ready,
  WorkInProgress,
  Done,
  NeedsArbitration,
  Success,
  Failed,
}
