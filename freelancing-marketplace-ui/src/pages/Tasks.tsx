import React, { useState } from "react";
import { Helmet } from "react-helmet";
import { Form, Button, Table } from "react-bootstrap";
import { BsFillInfoCircleFill } from "react-icons/bs";
import "./css/Tasks.css";
import { Task } from "../models/Task";
import { createNewTask } from "../Web3Client";


export default function Tasks() {
  const title = "Tasks";
  const [description, setDescription] = useState("");
  const [freelancerReward, setFreelancerReward] = useState(0);
  const [assessorReward, setAssessorReward] = useState(0);
  const [category, setCategory] = useState("");


  interface Props {
    tasks: Task[];
  }

  // handleSubmit = event  = {

  // }

  return (
    <>
      <Helmet>
        <title>{title}</title>
      </Helmet>
      <div className="page-container">
        <h2>Create a task</h2>
        <Form>
          <Form.Group className="mb-3" controlId="description">
            <Form.Control type="text" placeholder="Description"
              value={description}
              onChange={(event) => {
                setDescription(event.target.value);
              }} />
          </Form.Group>

          <Form.Group className="mb-3" controlId="freelancerReward">
            <Form.Control type="number" placeholder="Freelancer Reward"
              value={freelancerReward}
              onChange={(event) => {
                setFreelancerReward(parseInt(event.target.value));
              }} />
          </Form.Group>

          <Form.Group className="mb-3" controlId="assessorReward">
            <Form.Control type="number" placeholder="Assessor Reward"
              value={assessorReward}
              onChange={(event) => {
                setAssessorReward(parseInt(event.target.value));
              }} />
          </Form.Group>

          <Form.Group className="mb-3" controlId="category">
            <Form.Control type="text" placeholder="Category"
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
            <tr>
              <td>1</td>
              <td>Task1</td>
              <td>10</td>
              <td>15</td>
              <td>Math</td>
              <td><BsFillInfoCircleFill onClick={() => { alert('clicked') }} cursor="pointer" /></td>
            </tr>
            <tr>
              <td>2</td>
              <td>Task2</td>
              <td>20</td>
              <td>5</td>
              <td>Math</td>
              <td><BsFillInfoCircleFill onClick={() => { alert('clicked') }} cursor="pointer" /></td>
            </tr>
          </tbody>
        </Table>

      </div>
    </>
  );
}
