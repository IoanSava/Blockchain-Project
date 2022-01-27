import React from "react";
import { Helmet } from "react-helmet";
import { MarketplaceABI } from "../contracts/MarketplaceABI";
import "./css/Tasks.css";
import Web3 from "web3";
import { AbiItem } from "web3-utils";

const web3 = new Web3(new Web3.providers.HttpProvider("HTTP://127.0.0.1:7545"));
web3.eth.defaultAccount = web3.eth.accounts[0];

const RemixContract = new web3.eth.Contract(
  MarketplaceABI as AbiItem[],
  "0x204E51B0Cce6c7e60614a05cefe97a856005eb41"
);

export default function Tasks() {
  const title = "Tasks";

  RemixContract.methods.getTasks().call().then(console.log);

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
