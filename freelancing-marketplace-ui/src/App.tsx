import "./App.css";
import { useEffect } from "react";
import Home from "./pages/Home";
import Tasks from "./pages/Tasks";
import { BrowserRouter as Router, Switch, Route } from "react-router-dom";
import CustomNavbar from "./components/CustomNavbar";
import React from "react";
import Profile from "./pages/Profile";
import { init } from "./Web3Client";

function App() {
  useEffect(() => {
    init();
  }, []);

  return (
    <Router>
      <CustomNavbar />
      <Switch>
        <Route path="/" exact render={() => <Home />} />
        <Route path="/tasks" render={() => <Tasks />} />
        <Route path="/profile" render={() => <Profile />} />
      </Switch>
    </Router>
  );
}

export default App;
