import "./App.css";
import { useEffect } from "react";
import Home from "./pages/Home";
import Tasks from "./pages/Tasks";
import { BrowserRouter as Router, Switch, Route } from "react-router-dom";
import CustomNavbar from "./components/CustomNavbar";
import React from "react";
import Profile from "./pages/Profile";
import { init } from "./Web3Client";
import CreateTask from "./pages/CreateTask";
import TaskInformation from "./pages/TaskInformation";

function App() {
  useEffect(() => {
    init();
  }, []);

  return (
    <Router>
      <CustomNavbar />
      <Switch>
        <Route
          path="/tasks/:id"
          render={(props) => <TaskInformation {...props} />}
        />
        <Route path="/tasks" render={() => <Tasks />} />
        <Route path="/tasks-create" render={() => <CreateTask />} />
        <Route path="/profile" render={() => <Profile />} />
        <Route path="/" exact render={() => <Home />} />
      </Switch>
    </Router>
  );
}

export default App;
