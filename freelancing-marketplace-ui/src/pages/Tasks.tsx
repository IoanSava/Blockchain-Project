import React, { useState } from "react";
import { Helmet } from "react-helmet";
import { Form, Button, Table } from "react-bootstrap";
import { BsFillInfoCircleFill } from "react-icons/bs";
import "./css/Tasks.css";
import { Task } from "../models/Task";
import { createNewTask, getTasks, getAssessors } from "../Web3Client";
import data from "./mock-tasks.json";

export default function Tasks() {
  const title = "Tasks";
  const [description, setDescription] = useState("");
  const [freelancerReward, setFreelancerReward] = useState(0);
  const [assessorReward, setAssessorReward] = useState(0);
  const [category, setCategory] = useState("");
  const [tasks, setTasks] = useState(data);
  const [assessors, setAssessors] = useState("");
  const [listOfTasks, setListOfTasks] = useState();


  getTasks().then((listOfTasks) => setListOfTasks(listOfTasks));

  getAssessors().then((assessors) => setAssessors(assessors));

  interface Props {
    tasksList: Task[];
  }

  return (
    <>
      <Helmet>
        <title>{title}</title>
      </Helmet>
      <br />
      <div className="page-container">
        <p>Assessors: {assessors}.</p>
        <p>List of Tasks: {listOfTasks}.</p>
        <h2>Create a task</h2>
        <Form>
          <Form.Group className="mb-3" controlId="description">
            <Form.Label>Description</Form.Label>
            <Form.Control type="text" placeholder="Task1..."
              value={description}
              onChange={(event) => {
                setDescription(event.target.value);
              }} />
          </Form.Group>

          <Form.Group className="mb-3" controlId="freelancerReward">
            <Form.Label>Freelancer Reward</Form.Label>
            <Form.Control type="number" placeholder="15..."
              value={freelancerReward}
              onChange={(event) => {
                setFreelancerReward(parseInt(event.target.value));
              }} />
          </Form.Group>

          <Form.Group className="mb-3" controlId="assessorReward">
            <Form.Label>Assessor Reward</Form.Label>
            <Form.Control type="number" placeholder="10..."
              value={assessorReward}
              onChange={(event) => {
                setAssessorReward(parseInt(event.target.value));
              }} />
          </Form.Group>

          <Form.Group className="mb-3" controlId="category">
            <Form.Label>Category</Form.Label>
            <Form.Control type="text" placeholder="Math..."
              value={category}
              onChange={(event) => {
                setCategory(event.target.value);
              }} />
          </Form.Group>
          <Button variant="primary" type="submit"
            onClick={() => {
              createNewTask(description, freelancerReward, assessorReward, category)
                .then(result => {
                  console.log(result);
                })
            }}
          >
            Submit
          </Button>
        </Form>
        <br /><br />

        <h2>Available tasks</h2>
        <Table striped bordered hover className="tasks-table">
          <thead>
            <tr>
              <th>Id</th>
              <th>Description</th>
              <th>Freelancer Reward</th>
              <th>Assessor Reward</th>
              <th>Category</th>
              <th>More information</th>
            </tr>
          </thead>
          <tbody>
            {tasks.map((task, index) => (
              <tr key={index}>
                <td>{index + 1}</td>
                <td>{task.description}</td>
                <td>{task.freelancerReward}</td>
                <td>{task.assessorReward}</td>
                <td>{task.category}</td>
                <td><BsFillInfoCircleFill onClick={() => { alert('clicked') }} cursor="pointer" /></td>
              </tr>
            ))}
          </tbody>
        </Table>
      </div>
    </>
  );
}
