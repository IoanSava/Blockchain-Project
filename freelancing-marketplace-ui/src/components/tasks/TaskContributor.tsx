import React, { useEffect, useState } from "react";
import { Button, Form } from "react-bootstrap";
import { Props } from "../../commons/TaskActorProps";
import { TaskState } from "../../models/Task";
import {
  financeTask,
  getContributorContributionForTask,
  getCurrentFunds,
  withdrawFunds,
} from "../../Web3Client";

export default function TaskContributor(props: Props) {
  const { task, address } = props;

  const [tokens, setTokens] = useState(0);
  const [contribution, setContribution] = useState(0);
  const [tokensToContribute, setTokensToContribute] = useState(0);
  const [tokensToWithdraw, setTokensToWithdraw] = useState(0);

  useEffect(() => {
    async function init() {
      const currentTokens: number = await getCurrentFunds();
      setTokens(currentTokens);
      const currentContribution: number =
        await getContributorContributionForTask(task.id);
      setContribution(currentContribution);
    }
    init();
  }, []);

  if (task.state == TaskState.Financing) {
    return (
      <>
        <p>Current contribution: {contribution}</p>
        <Form.Label>Tokens to contribute: {tokensToContribute}</Form.Label>
        <Form.Range
          style={{ width: "30%", margin: "auto" }}
          min={0}
          max={tokens}
          value={tokensToContribute}
          onChange={(event) => {
            setTokensToContribute(parseInt(event.target.value));
          }}
        />
        <Button
          variant="primary"
          onClick={() => {
            financeTask(task.id, tokensToContribute)
              .then(() => alert("The task was financed"))
              .catch(() => alert("Failed to transfer tokens to marketplace"));
          }}
        >
          Contribute
        </Button>

        <Form.Label>Tokens to withdraw: {tokensToWithdraw}</Form.Label>
        <Form.Range
          style={{ width: "30%", margin: "auto" }}
          min={0}
          max={contribution}
          value={tokensToWithdraw}
          onChange={(event) => {
            setTokensToWithdraw(parseInt(event.target.value));
          }}
        />
        <Button
          variant="primary"
          onClick={() => {
            withdrawFunds(task.id, tokensToWithdraw)
              .then(() => alert("Withdrawal succeeded"))
              .catch(() => alert("Funds withdrawal failed"));
          }}
        >
          Withdraw
        </Button>
      </>
    );
  }
  return <></>;
}
