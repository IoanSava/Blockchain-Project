import { Task, TaskState } from "../models/Task";

export const mockTask: Task = {
  id: 1,
  description: "",
  freelancerReward: 1,
  assessorReward: 1,
  category: "",
  managerAddress: "",
  assessorAddress: "",
  freelancerAddress: "",
  currentFunds: 1,
  state: TaskState.Financing,
};
