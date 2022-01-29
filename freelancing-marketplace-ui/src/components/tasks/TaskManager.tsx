import React from "react";
import { Button } from "react-bootstrap";
import { Props } from "../../commons/TaskActorProps";
import { TaskState } from "../../models/Task";
import { cancelTask } from "../../Web3Client";

export default function TaskManager(props: Props) {
  const { task, address } = props;

  if (
    task.state == TaskState.Financing &&
    task.managerAddress.toLowerCase() === address.toLowerCase()
  ) {
    return (
      <Button
        variant="danger"
        onClick={() => {
          cancelTask(task.id)
            .then(() => alert("The task was canceled"))
            .catch(() => alert("Task cancelation failed"));
        }}
      >
        Cancel task
      </Button>
    );
  }
  return <></>;
}
