import React, { useEffect, useState } from "react";
import { Helmet } from "react-helmet";
import { Button, Table } from "react-bootstrap";
import { BsFillInfoCircleFill } from "react-icons/bs";
import "./css/Tasks.css";
import { getRoleByAddress, getTasks } from "../Web3Client";
import { Task, TaskState } from "../models/Task";
import { useHistory } from "react-router-dom";

export default function Tasks() {
  const title = "Tasks";

  const [role, setRole] = useState("");
  const [tasks, setTasks] = useState<Task[]>([]);

  const history = useHistory();

  useEffect(() => {
    async function init() {
      const currentTasks: Task[] = await getTasks();
      setTasks(currentTasks);
      const currentRole: string = await getRoleByAddress();
      setRole(currentRole);
    }
    init();
  }, []);

  return (
    <>
      <Helmet>
        <title>{title}</title>
      </Helmet>
      <br />
      <div className="page-container">
        {role === "manager" && (
          <Button variant="primary" href="/tasks-create">
            Create a task
          </Button>
        )}

        <h2>Tasks</h2>
        <Table striped bordered hover className="tasks-table">
          <thead>
            <tr>
              <th>Id</th>
              <th>Description</th>
              <th>Category</th>
              <th>Freelancer Reward</th>
              <th>Assessor Reward</th>
              <th>Manager address</th>
              <th>State</th>
              <th>More information</th>
            </tr>
          </thead>
          <tbody>
            {tasks.map((task: Task, index: number) => (
              <tr key={index}>
                <td>{task.id}</td>
                <td>{task.description}</td>
                <td>{task.category}</td>
                <td>{task.freelancerReward}</td>
                <td>{task.assessorReward}</td>
                <td>{task.managerAddress}</td>
                <td>{TaskState[task.state]}</td>
                <td>
                  <BsFillInfoCircleFill
                    onClick={() => {
                      history.push(`/tasks/${task.id}`);
                    }}
                    cursor="pointer"
                  />
                </td>
              </tr>
            ))}
          </tbody>
        </Table>
      </div>
    </>
  );
}
