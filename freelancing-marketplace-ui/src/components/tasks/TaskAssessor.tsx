import React from "react";
import { Button } from "react-bootstrap";
import { Props } from "../../commons/TaskActorProps";
import { TaskState } from "../../models/Task";
import { acceptTaskByAssessor, declineTaskByAssessor } from "../../Web3Client";

export default function TaskAssessor(props: Props) {
  const { task, address } = props;

  if (
    task.state == TaskState.NeedsArbitration &&
    task.assessorAddress.toLowerCase() === address.toLowerCase()
  ) {
    return (
      <>
        <Button
          variant="success"
          onClick={() => {
            acceptTaskByAssessor(task.id)
              .then(() => alert("You accepted the task."))
              .catch(() => alert("Accepting the task failed."));
          }}
        >
          Accept task
        </Button>
        <br />
        <Button
          variant="danger"
          onClick={() => {
            declineTaskByAssessor(task.id)
              .then(() => alert("You declined the task."))
              .catch(() => alert("Declining the task failed."));
          }}
        >
          Decline task
        </Button>
      </>
    );
  }
  return <></>;
}
