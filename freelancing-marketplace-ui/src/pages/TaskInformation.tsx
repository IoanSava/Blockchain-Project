import React from "react";
import { Helmet } from "react-helmet";

export default function TaskInformation(props: any) {
  const title = "Task information";
  const id = props.match.params.id;

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
