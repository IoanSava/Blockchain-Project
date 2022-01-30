import React, { useState } from "react";
import { Button, Form } from "react-bootstrap";
import { Helmet } from "react-helmet";
import { createNewTask } from "../Web3Client";

export default function CreateTask() {
  const title = "Create task";

  const [description, setDescription] = useState("");
  const [freelancerReward, setFreelancerReward] = useState(0);
  const [assessorReward, setAssessorReward] = useState(0);
  const [category, setCategory] = useState("");

  return (
    <>
      <Helmet>
        <title>{title}</title>
      </Helmet>
      <div className="page-container">
        <div className="title">
          <h2>Create a task</h2>
          <Form>
            <Form.Group className="mb-3" controlId="description">
              <Form.Label>Description</Form.Label>
              <Form.Control
                type="text"
                placeholder="VR"
                value={description}
                onChange={(event) => {
                  setDescription(event.target.value);
                }}
              />
            </Form.Group>

            <Form.Group className="mb-3" controlId="freelancerReward">
              <Form.Label>Freelancer Reward</Form.Label>
              <Form.Control
                type="number"
                min={0}
                value={freelancerReward}
                onChange={(event) => {
                  setFreelancerReward(
                    parseInt(event.target.value) || freelancerReward
                  );
                }}
              />
            </Form.Group>

            <Form.Group className="mb-3" controlId="assessorReward">
              <Form.Label>Assessor Reward</Form.Label>
              <Form.Control
                type="number"
                min={0}
                value={assessorReward}
                onChange={(event) => {
                  setAssessorReward(
                    parseInt(event.target.value) || assessorReward
                  );
                }}
              />
            </Form.Group>

            <Form.Group className="mb-3" controlId="category">
              <Form.Label>Category</Form.Label>
              <Form.Control
                type="text"
                placeholder="Web"
                value={category}
                onChange={(event) => {
                  setCategory(event.target.value);
                }}
              />
            </Form.Group>

            <Button
              variant="primary"
              type="submit"
              onClick={(event) => {
                event.preventDefault();
                createNewTask(
                  description,
                  freelancerReward,
                  assessorReward,
                  category.toLowerCase()
                )
                  .then(() => alert("Task created"))
                  .catch(() => alert("Task creation failed"));
              }}
            >
              Submit
            </Button>
          </Form>
        </div>
      </div>
    </>
  );
}
