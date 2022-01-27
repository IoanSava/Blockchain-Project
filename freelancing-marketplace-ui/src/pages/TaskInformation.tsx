import React from "react";
import { Helmet } from "react-helmet";

export default function TaskInformation() {
  const title = "TaskInformation";

  return (
    <>
      <Helmet>
        <title>{title}</title>
      </Helmet>
      <div className="page-container">
        <div className="title">
          <h1>Task Information</h1>
        </div>
      </div>
    </>
  );
}
