import React from "react";
import { Helmet } from "react-helmet";
import "./css/Home.css";

export default function Home() {
  const title = "Home";

  return (
    <>
      <Helmet>
        <title>{title}</title>
      </Helmet>
      <div className="page-container">
        <div className="title">
          <h1>Freelancing</h1>
          <h1 className="white-fill">Marketplace</h1>
        </div>
      </div>
    </>
  );
}
