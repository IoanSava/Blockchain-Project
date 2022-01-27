import "./App.css";
import Web3 from "web3";
import { useEffect } from "react";
import Home from "./pages/Home";
import Tasks from "./pages/Tasks";
import { BrowserRouter as Router, Switch, Route } from "react-router-dom";
import CustomNavbar from "./components/CustomNavbar";
import React from "react";

function App() {
  const providerUrl = process.env.PROVIDER_URL || "http://127.0.0.1:7545";

  useEffect(() => {
    const web3 = new Web3(providerUrl);

    let provider = (window as any).ethereum;
    if (typeof provider !== "undefined") {
      // Metamask is installed

      provider
        .request({ method: "eth_requestAccounts" })
        .then((accounts: any) => console.log(accounts))
        .catch((error: any) => console.error(error));
    }
  });

  return (
    <Router>
      <CustomNavbar />
      <Switch>
        <Route path="/" exact render={() => <Home />} />
        <Route path="/tasks" render={() => <Tasks />} />
      </Switch>
    </Router>
  );
}

export default App;
