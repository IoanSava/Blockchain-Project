import React, { useEffect, useState } from "react";
import { Card, ListGroup, ListGroupItem } from "react-bootstrap";
import { Helmet } from "react-helmet";
import { mockTask } from "../mocks/mock-task";
import { Task, TaskState } from "../models/Task";
import { getAddress, getRoleByAddress, getTaskById } from "../Web3Client";
import TaskManager from "../components/tasks/TaskManager";
import TaskContributor from "../components/tasks/TaskContributor";
import TaskFreelancer from "../components/tasks/TaskFreelancer";
import TaskAssessor from "../components/tasks/TaskAssessor";

export default function TaskInformation(props: any) {
  const title = "Task information";
  const id = props.match.params.id;

  const [task, setTask] = useState<Task>(mockTask);
  const [role, setRole] = useState("");
  const [address, setAddress] = useState("");

  useEffect(() => {
    async function init() {
      const currentTask: Task = await getTaskById(id);
      setTask(currentTask);
      const currentRole: string = await getRoleByAddress();
      setRole(currentRole);
      const currentAddress: string = getAddress();
      setAddress(currentAddress);
    }
    init();
  }, []);

  return (
    <>
      <Helmet>
        <title>{title}</title>
      </Helmet>
      <div className="page-container">
        <Card style={{ width: "50%", margin: "auto" }}>
          <Card.Body>
            <Card.Title>Task {task.id}</Card.Title>
            <Card.Text>{task.description}</Card.Text>
          </Card.Body>
          <ListGroup className="list-group-flush">
            <ListGroupItem>{task.category}</ListGroupItem>
            <ListGroupItem>
              Manager address: {task.managerAddress}
            </ListGroupItem>
            <ListGroupItem>
              Freelancer address: {task.freelancerAddress}
            </ListGroupItem>
            <ListGroupItem>
              Freelancer reward: {task.freelancerReward}
            </ListGroupItem>
            <ListGroupItem>
              Assessor address: {task.assessorAddress}
            </ListGroupItem>
            <ListGroupItem>
              Assessor reward: {task.assessorReward}
            </ListGroupItem>
            <ListGroupItem>Current funds: {task.currentFunds}</ListGroupItem>
            <ListGroupItem>State: {TaskState[task.state]}</ListGroupItem>
          </ListGroup>
        </Card>
        {role === "manager" && <TaskManager task={task} address={address} />}
        {role === "contributor" && <TaskContributor task={task} address={address} />}
        {role === "freelancer" && <TaskFreelancer task={task} address={address} />}
        {role === "assessor" && <TaskAssessor task={task} address={address} />}
      </div>
    </>
  );
}
