import React from "react";
import { Helmet } from "react-helmet";
import { getCurrentFunds } from "../Web3Client";

export default function Profile() {
  const title = "Profile";
  const [tokens, setTokens] = React.useState(0);

  getCurrentFunds().then((funds) => setTokens(funds));

  return (
    <>
      <Helmet>
        <title>{title}</title>
      </Helmet>
      <div className="page-container">
        <div className="title">
          <h1>Profile</h1>
        </div>
        <p>Your funds: {tokens} tokens.</p>
      </div>
    </>
  );
}
