import React, { useEffect, useState } from "react";
import { Button, Form } from "react-bootstrap";
import { Props } from "../../commons/TaskActorProps";
import { Assessor } from "../../models/Assessor";
import { Freelancer } from "../../models/Freelancer";
import { TaskState } from "../../models/Task";
import {
  acceptTaskByManager,
  assignAssessorForTask,
  cancelTask,
  declineTaskByManager,
  getApplicationsForTask,
  getAssessors,
  selectFreelancerForTask,
} from "../../Web3Client";

export default function TaskManager(props: Props) {
  const { task, address } = props;

  const [assessors, setAssessors] = useState<Assessor[]>([]);
  const [selectedAssessorAddress, setSelectedAssessorAddress] = useState("");

  const [freelancers, setFreelancers] = useState<Freelancer[]>([]);
  const [selectedFreelancerAddress, setSelectedFreelancerAddress] =
    useState("");

  useEffect(() => {
    async function init() {
      const currentAssessors: Assessor[] = await getAssessors();
      const filteredAssessors: Assessor[] = currentAssessors.filter(
        (assessor: Assessor) => assessor.category.toLowerCase() === task.category.toLowerCase()
      );
      setAssessors(filteredAssessors);
      if (filteredAssessors.length > 0) {
        setSelectedAssessorAddress(filteredAssessors[0].assessorAddress);
      }

      const currentFreelancers: Freelancer[] = await getApplicationsForTask(
        task.id
      );
      setFreelancers(currentFreelancers);
      if (currentFreelancers.length > 0) {
        setSelectedFreelancerAddress(currentFreelancers[0].freelancerAddress);
      }
    }
    init();
  }, []);

  if (task.managerAddress.toLowerCase() === address.toLowerCase()) {
    if (task.state == TaskState.Financing) {
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
    } else if (task.state == TaskState.Financed) {
      return (
        <>
          {assessors.length > 0 && (
            <Form.Select
              style={{ width: "35%", margin: "auto" }}
              aria-label="Assessor"
              onChange={(event) => {
                setSelectedAssessorAddress(event.target.value);
              }}
            >
              {assessors.map((assessor: Assessor, index: number) => (
                <option key={index} value={assessor.assessorAddress}>
                  {assessor.name} - {assessor.assessorAddress}
                </option>
              ))}
            </Form.Select>
          )}
          <Button
            variant="primary"
            disabled={assessors.length === 0}
            onClick={() => {
              assignAssessorForTask(selectedAssessorAddress, task.id)
                .then(() => alert("The assessor was assigned"))
                .catch(() => alert("The assessor assignment failed"));
            }}
          >
            Assign assessor
          </Button>
        </>
      );
    } else if (task.state == TaskState.Ready) {
      return (
        <>
          {freelancers.length > 0 && (
            <Form.Select
              style={{ width: "40%", margin: "auto" }}
              aria-label="Freelancer"
              onChange={(event) => {
                setSelectedFreelancerAddress(event.target.value);
              }}
            >
              {freelancers.map((freelancer: Freelancer, index: number) => (
                <option key={index} value={freelancer.freelancerAddress}>
                  {freelancer.name} - {freelancer.freelancerAddress}{" "}
                  (reputation: {freelancer.reputation})
                </option>
              ))}
            </Form.Select>
          )}
          <Button
            variant="primary"
            disabled={freelancers.length === 0}
            onClick={() => {
              selectFreelancerForTask(selectedFreelancerAddress, task.id)
                .then(() => alert("The freelancer was assigned"))
                .catch(() => alert("The freelancer assignment failed"));
            }}
          >
            Assign freelancer
          </Button>
        </>
      );
    } else if (task.state == TaskState.Done) {
      return (
        <>
          <Button
            variant="success"
            onClick={() => {
              acceptTaskByManager(task.id)
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
              declineTaskByManager(task.id)
                .then(() => alert("You declined the task."))
                .catch(() => alert("Declining the task failed."));
            }}
          >
            Decline task
          </Button>
        </>
      );
    }
  }
  return <></>;
}
