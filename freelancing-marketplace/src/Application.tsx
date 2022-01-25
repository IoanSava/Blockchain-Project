import React from "react";
import "./Application.css";
import { BrowserRouter as Router, Switch, Route } from "react-router-dom";
import Home from "./pages/Home";
import CustomNavbar from "./components/CustomNavbar";
import Tasks from "./pages/Tasks";

export default function Application() {
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
