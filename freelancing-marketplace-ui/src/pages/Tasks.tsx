import React from "react";
import { Helmet } from "react-helmet";

export default function Tasks() {
  const title = "Tasks";

  return (
    <>
      <Helmet>
        <title>{title}</title>
      </Helmet>
      <div className="page-container">
        <div className="title">
          <h1>Tasks</h1>
        </div>
      </div>
    </>
  );
}
