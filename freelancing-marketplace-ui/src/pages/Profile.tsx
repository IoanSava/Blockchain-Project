import React, { useEffect, useState } from "react";
import { Helmet } from "react-helmet";
import { getAddress, getCurrentFunds, getRoleByAddress } from "../Web3Client";

export default function Profile() {
  const title = "Profile";
  const address = getAddress();

  const [tokens, setTokens] = useState(0);
  const [role, setRole] = useState("");

  useEffect(() => {
    async function init() {
      const currentTokens: number = await getCurrentFunds();
      setTokens(currentTokens);
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
      <div className="page-container">
        <div className="title">
          <h1>Profile</h1>
        </div>
        <p>You are a {role}.</p>
        <p>Your funds: {tokens} tokens.</p>
        <p>
          Your address: <strong>{address}</strong>.
        </p>
      </div>
    </>
  );
}
