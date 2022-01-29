import React, { useState } from "react";
import { useEffect } from "react";
import { Button } from "react-bootstrap";
import { Props } from "../../commons/TaskActorProps";
import { mockFreelancer } from "../../mocks/mock-freelancer";
import { Freelancer } from "../../models/Freelancer";
import { TaskState } from "../../models/Task";
import {
  applyForTask,
  getFreelancerByAddress,
  markTaskAsDone,
} from "../../Web3Client";

export default function TaskFreelancer(props: Props) {
  const { task, address } = props;

  const [freelancer, setFreelancer] = useState<Freelancer>(mockFreelancer);

  useEffect(() => {
    async function init() {
      const currentFreelancer: Freelancer = await getFreelancerByAddress();
      setFreelancer(currentFreelancer);
    }
    init();
  }, []);

  if (
    task.state == TaskState.Ready &&
    task.category.toLowerCase() === freelancer.category.toLowerCase()
  ) {
    return (
      <Button
        variant="success"
        onClick={() => {
          applyForTask(task.id, task.assessorReward)
            .then(() => alert("You applied for the task."))
            .catch(() => alert("Application for task failed."));
        }}
      >
        Apply for task
      </Button>
    );
  } else if (
    task.state == TaskState.WorkInProgress &&
    task.freelancerAddress.toLowerCase() === address.toLowerCase()
  ) {
    return (
      <Button
        variant="success"
        onClick={() => {
          markTaskAsDone(task.id)
            .then(() => alert("The task was marked as done."))
            .catch(() => alert("Marking the task as done failed."));
        }}
      >
        Mark as done
      </Button>
    );
  }
  return <></>;
}
