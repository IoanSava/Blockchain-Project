// SPDX-License-Identifier: MIT

pragma solidity >= 0.8.0 <= 0.8.7;

import "./Token.sol";

contract Marketplace {
    uint256 private DEFAULT_REPUTATION = 5;
    uint256 private TOKENS_INITIAL_SUPPLY = 1000;
    uint256 private MIN_REPUTATION = 1;
    uint256 private MAX_REPUTATION = 10;

    Token private token;
    event TokenCreated(address tokenAddress);

    manager private managerVar;
    mapping (address => manager) private managers;
    mapping (address => bool) private managerAddresses;

    freelancer private freelancerVar;
    mapping (address => freelancer) private freelancers;
    mapping (address => bool) private freelancerAddresses;

    assessor private assessorVar;
    mapping (address => assessor) private assessors;
    mapping (address => bool) assessorAddresses;
    assessor[] private assessorsList;

    contributor private contributorVar;
    mapping (address => contributor) private contributors;
    mapping (address => bool) contributorAddresses;

    task private taskVar;
    uint256 private numberOfTasks;
    task[] private tasksList;

    contributorContribution private contributorContributionVar;
    mapping(uint256 => contributorContribution[]) tasksContributions;

    mapping(uint256 => freelancer[]) tasksFreelancers;
    
    struct manager {
        string name;
    }

    struct freelancer {
        address freelancerAddress;
        string name;
        string category;
        uint256 reputation;
    }

    struct assessor {
        string name;
        string category;
        address assessorAddress;
    }

    struct contributor {
        string name;
    }

    enum TaskState {
        Financing,
        Financed,
        Canceled,
        Ready,
        WorkInProgress,
        Done,
        NeedsArbitration,
        Success,
        Failed
    }

    struct task {
        uint256 id;
        string description;
        uint256 freelancerReward; // number of tokens
        uint256 assessorReward; // number of tokens
        string category;
        address managerAddress;
        address assessorAddress;
        address freelancerAddress;
        uint256 currentFunds; // number of tokens
        TaskState state;
    }

    struct contributorContribution {
        address contributorAddress;
        uint256 contribution; // number of tokens
    }

    modifier onlyManager() {
        require(managerAddresses[msg.sender], "[Marketplace] You are not a manager!");
        _;
    }

    modifier onlyContributor() {
        require(contributorAddresses[msg.sender], "[Marketplace] You are not a contributor!");
        _;
    }

    modifier onlyFreelancer() {
        require(freelancerAddresses[msg.sender], "[Marketplace] You are not a freelancer!");
        _;
    }

    modifier onlyAssessor() {
        require(assessorAddresses[msg.sender], "[Marketplace] You are not an assessor!");
        _;
    }

    constructor(
        address _managerAddress,
        address _firstContributorAddress,
        address _secondContributorAddress,
        address _firstAssessorAddress,
        address _secondAssessorAddress,
        address _firstFreelancerAddress,
        address _secondFreelancerAddress,
        address _thirdFreelancerAddress
    ) {
        token = new Token(TOKENS_INITIAL_SUPPLY);
        emit TokenCreated(address(token));

        createManager("George", _managerAddress);

        createContributor("John", _firstContributorAddress);
        token.transfer(_firstContributorAddress, TOKENS_INITIAL_SUPPLY / 4);

        createContributor("Mike", _secondContributorAddress);
        token.transfer(_secondContributorAddress, TOKENS_INITIAL_SUPPLY / 4);

        createAssessor("Anna", "web", _firstAssessorAddress);
        createAssessor("Joe", "mobile", _secondAssessorAddress);

        createFreelancer("Andres", "web", _firstFreelancerAddress);
        token.transfer(_firstFreelancerAddress, TOKENS_INITIAL_SUPPLY / 4);

        createFreelancer("Kamila", "mobile", _secondFreelancerAddress);
        token.transfer(_secondFreelancerAddress, TOKENS_INITIAL_SUPPLY / 8);

        createFreelancer("Tobias", "mobile", _thirdFreelancerAddress);
        token.transfer(_thirdFreelancerAddress, TOKENS_INITIAL_SUPPLY / 8);
    }

    function getRoleByAddress(address _address) public view returns (string memory) {
        if (managerAddresses[_address]) {
            return "manager";
        }

        if (freelancerAddresses[_address]) {
            return "freelancer";
        }

        if (contributorAddresses[_address]) {
            return "contributor";
        }

        if (assessorAddresses[_address]) {
            return "assessor";
        }

        return "unknown";
    }

    function compareStrings(string memory str1, string memory str2) private pure returns (bool) {
        return (keccak256(abi.encodePacked((str1))) == keccak256(abi.encodePacked((str2))));
    }

    function createManager(string memory _name, address _address) private returns (string memory) {
        managerVar = manager(_name);
        managers[_address] = managerVar;
        managerAddresses[_address] = true;
        return "[Marketplace] Manager created";
    }

    function createFreelancer(string memory _name, string memory _category, address _address) private returns (string memory) {
        freelancerVar = freelancer(_address, _name, _category, DEFAULT_REPUTATION);
        freelancers[_address] = freelancerVar;
        freelancerAddresses[_address] = true;
        return "[Marketplace] Freelancer created";
    }

    function getFreelancerByAddress(address _address) public view returns(freelancer memory) {
        return freelancers[_address];
    }

    function createAssessor(string memory _name, string memory _category, address _address) private returns (string memory) {
        assessorVar = assessor(_name, _category, _address);
        assessors[_address] = assessorVar;
        assessorsList.push(assessorVar);
        assessorAddresses[_address] = true;
        return "[Marketplace] Assessor created";
    }

    function getAssessors() public view returns(assessor[] memory) {
        return assessorsList;
    }

    function createContributor(string memory _name, address _address) private returns (string memory) {
        contributorVar = contributor(_name);
        contributors[_address] = contributorVar;
        contributorAddresses[_address] = true;
        return "[Marketplace] Contributor created";
    }

    function createTask(string calldata _description, uint256 _freelancerReward, uint256 _assessorReward, string calldata _category) public onlyManager returns (string memory) {
        numberOfTasks++;
        taskVar = task(numberOfTasks, _description, _freelancerReward, _assessorReward, _category, msg.sender, address(0), address(0), 0, TaskState.Financing);
        tasksList.push(taskVar);
        return "[Marketplace] Task created";
    }

    function getTasks() public view returns(task[] memory) {
        return tasksList;
    }

    function getTaskById(uint256 _taskId) public view returns(task memory) {
        return tasksList[_taskId - 1];
    }

    function getContributionsForTask(uint256 _taskId) public view returns(contributorContribution[] memory) {
        return tasksContributions[_taskId];
    }

    function returnContributionsForTask(uint256 _taskId) private {
        uint256 numberOfContributions = tasksContributions[_taskId].length;
        for (uint256 i = 0; i < numberOfContributions; ++i) {
            address contributorAddress = tasksContributions[_taskId][i].contributorAddress;
            uint256 contribution = tasksContributions[_taskId][i].contribution;
            token.transfer(contributorAddress, contribution);
            tasksContributions[_taskId][i].contribution = 0;
        }
    }

    function cancelTask(uint256 _taskId) public onlyManager returns (string memory) {
        for (uint256 i = 0; i < numberOfTasks; ++i) {
            if (tasksList[i].id == _taskId) {
                require(tasksList[i].state == TaskState.Financing, "[Marketplace] The task must be in Financing state.");
                require(tasksList[i].managerAddress == msg.sender, "[Marketplace] You can not cancel the task of another manager.");
                
                returnContributionsForTask(_taskId);
                tasksList[i].state = TaskState.Canceled;
                tasksList[i].currentFunds = 0;
                return "[Marketplace] The task was canceled.";
            }
        }
        return "[Marketplace] The task was not found.";   
    }

    function getTasksByState(TaskState _state) private view returns(task[] memory) {
        uint256 resultCount;
        for (uint256 i = 0; i < numberOfTasks; ++i) {
            if (tasksList[i].state == _state) {
                resultCount++; 
            }
        }

        task[] memory tasks = new task[](resultCount);
        uint256 newIndex;

        for (uint i = 0; i < numberOfTasks; ++i) {
            if (tasksList[i].state == _state) {
                tasks[newIndex] = tasksList[i];
                newIndex++;
            }
        }
        return tasks;
    }

    function getFinancingTasks() public view returns(task[] memory) {
        return getTasksByState(TaskState.Financing);
    }

    function getFinancedTasks() public view returns(task[] memory) {
        return getTasksByState(TaskState.Financed);
    }

    function getReadyTasks() public view returns(task[] memory) {
        return getTasksByState(TaskState.Ready);
    }

    function getWorkInProgressTasks() public view returns(task[] memory) {
        return getTasksByState(TaskState.WorkInProgress);
    }

    function getDoneTasks() public view returns(task[] memory) {
        return getTasksByState(TaskState.Done);
    }

    function getNeedsArbitrationTasks() public view returns(task[] memory) {
        return getTasksByState(TaskState.NeedsArbitration);
    }

    function getContributorContributionIndexForTask(address _contributorAddress, uint256 _taskId) private view returns(int256) {
        uint256 numberOfContributions = tasksContributions[_taskId].length;
        for (uint256 i = 0; i < numberOfContributions; ++i) {
            if (tasksContributions[_taskId][i].contributorAddress == _contributorAddress) {
                return int(i);
            }
        }
        return -1;
    }

    function getContributorContributionForTask(address _contributorAddress, uint256 _taskId) public view returns(uint256) {
        uint256 numberOfContributions = tasksContributions[_taskId].length;
        for (uint256 i = 0; i < numberOfContributions; ++i) {
            if (tasksContributions[_taskId][i].contributorAddress == _contributorAddress) {
                return tasksContributions[_taskId][i].contribution;
            }
        }
        return 0;
    }

    function createContributorContribution(address _contributorAddress, uint256 _contributionValue, uint256 _taskId) private {
        contributorContributionVar = contributorContribution(_contributorAddress, _contributionValue);
        tasksContributions[_taskId].push(contributorContributionVar);
    }

    function financeTask(uint256 _taskId, uint256 _tokenAmount) external onlyContributor returns (string memory) {
        require(_tokenAmount > 0, "[Marketplace] Invalid amount of tokens");
        uint256 tokenBalance = token.balanceOf(msg.sender);
        require(tokenBalance >= _tokenAmount, "[Marketplace] You don't have enough tokens");
        
        for (uint256 i = 0; i < numberOfTasks; ++i) {
            if (tasksList[i].id == _taskId) {
                require(tasksList[i].state == TaskState.Financing, "[Marketplace] The task must be in Financing state.");
                
                bool sent = token.transferFrom(msg.sender, address(this), _tokenAmount);
                require(sent, "[Marketplace] Failed to transfer tokens to marketplace");

                int256 contributorContributionIndex = getContributorContributionIndexForTask(msg.sender, _taskId);
                if (contributorContributionIndex == -1) {
                    // The contributor has not contributed to this task, it creates a new contribution
                    createContributorContribution(msg.sender, _tokenAmount, _taskId);
                }
                else {
                    // The contributor has already contributed to this task, it adds the funds to the previous contribution
                    tasksContributions[_taskId][uint256(contributorContributionIndex)].contribution += _tokenAmount;
                }

                tasksList[i].currentFunds += _tokenAmount;
                uint256 fundingGoal = tasksList[i].freelancerReward + tasksList[i].assessorReward;
                if (tasksList[i].currentFunds >= fundingGoal) {
                    tasksList[i].state = TaskState.Financed;

                    // check if the investment has been exceeded
                    uint256 surplus = tasksList[i].currentFunds - fundingGoal;
                    if (surplus > 0) {
                        token.transfer(msg.sender, surplus);
                        tasksList[i].currentFunds -= surplus;
                        tasksContributions[_taskId][uint256(contributorContributionIndex)].contribution -= surplus;
                    }
                }

                return "[Marketplace] We received your contribution.";
            }
        }
        return "[Marketplace] The task was not found.";
    }

    function withdrawFunds(uint256 _taskId, uint256 _tokenAmount) external onlyContributor returns (string memory) {
        require(_tokenAmount > 0, "[Marketplace] Invalid amount of tokens");

        for (uint256 i = 0; i < numberOfTasks; ++i) {
            if (tasksList[i].id == _taskId) {
                require(tasksList[i].state == TaskState.Financing, "[Marketplace] The task must be in Financing state.");

                int256 contributorContributionIndex = getContributorContributionIndexForTask(msg.sender, _taskId);
                if (contributorContributionIndex == -1) {
                    // The contributor has not contributed to this task
                    return "[Marketplace] You have not contributed to this task.";
                }

                uint256 currentTaskContribution = tasksContributions[_taskId][uint256(contributorContributionIndex)].contribution;
                if (currentTaskContribution < _tokenAmount) {
                    return "[Marketplace] Your contribution is lower.";
                }

                token.transfer(msg.sender, _tokenAmount);
                tasksList[i].currentFunds -= _tokenAmount;
                tasksContributions[_taskId][uint256(contributorContributionIndex)].contribution -= _tokenAmount;

                return "[Marketplace] Withdrawal succeeded.";
            }
        }

        return "[Marketplace] The task was not found.";
    }

    function assignAssessorForTask(address _assessorAddress, uint256 _taskId) public onlyManager returns (string memory) {
        require(assessorAddresses[_assessorAddress], "[Marketplace] The assessor was not found.");

        for (uint256 i = 0; i < numberOfTasks; ++i) {
            if (tasksList[i].id == _taskId) {
                require(tasksList[i].state == TaskState.Financed, "[Marketplace] The task must be in Financed state.");
                require(tasksList[i].managerAddress == msg.sender, "[Marketplace] You can not assign an assessor for the task of another manager.");
                require(compareStrings(tasksList[i].category, assessors[_assessorAddress].category), "[Marketplace] The category of the task must be the same as that of the assessor.");

                tasksList[i].assessorAddress = _assessorAddress;
                tasksList[i].state = TaskState.Ready;
                return "[Marketplace] The assessor was assigned for the task.";
            }
        }
        return "[Marketplace] The task was not found.";
    }

    function doesFreelancerAppliedForTask(address _freelancerAddress, uint256 _taskId) private view returns (bool) {
        uint256 numberOfApplications = tasksFreelancers[_taskId].length;
        for (uint256 i = 0; i < numberOfApplications; ++i) {
            if (tasksFreelancers[_taskId][i].freelancerAddress == _freelancerAddress) {
                return true;
            }
        }
        return false;
    }

    function applyForTask(uint256 _taskId) external onlyFreelancer returns (string memory) {
        for (uint256 i = 0; i < numberOfTasks; ++i) {
            if (tasksList[i].id == _taskId) {
                require(tasksList[i].state == TaskState.Ready, "[Marketplace] The task must be in Ready state.");
                require(compareStrings(tasksList[i].category, freelancers[msg.sender].category), "[Marketplace] The category of the task must be the same as that of the freelancer.");
                require(!doesFreelancerAppliedForTask(msg.sender, _taskId), "[Marketplace] You already applied for this task.");
            
                tasksFreelancers[_taskId].push(freelancers[msg.sender]);
                bool sent = token.transferFrom(msg.sender, address(this), tasksList[i].assessorReward);
                require(sent, "[Marketplace] Failed to transfer tokens to marketplace");

                return "[Marketplace] We received your application.";
            }
        }
        return "[Marketplace] The task was not found.";
    }

    function getApplicationsForTask(uint256 _taskId) public view returns(freelancer[] memory) {
        return tasksFreelancers[_taskId];
    }

    function selectFreelancerForTask(address _freelancerAddress, uint256 _taskId) public onlyManager returns (string memory) {
        require(freelancerAddresses[_freelancerAddress], "[Marketplace] The freelancer was not found.");
        require(doesFreelancerAppliedForTask(_freelancerAddress, _taskId), "[Marketplace] The freelancer did not apply for the task.");

        for (uint256 i = 0; i < numberOfTasks; ++i) {
            if (tasksList[i].id == _taskId) {
                require(tasksList[i].state == TaskState.Ready, "[Marketplace] The task must be in Ready state.");

                tasksList[i].state = TaskState.WorkInProgress;
                tasksList[i].freelancerAddress = _freelancerAddress;

                uint256 numberOfApplications = tasksFreelancers[_taskId].length;
                for (uint256 j = 0; j < numberOfApplications; ++j) {
                    if (tasksFreelancers[_taskId][j].freelancerAddress != _freelancerAddress) {
                        token.transfer(tasksFreelancers[_taskId][j].freelancerAddress,  tasksList[i].assessorReward);
                    }
                }

                return "[Marketplace] Freelancer assgined.";
            }
        }

        return "[Marketplace] The task was not found.";
    }

    function getTasksOfFreelancer() public view onlyFreelancer returns (task[] memory) {
        uint256 resultCount;
        for (uint256 i = 0; i < numberOfTasks; ++i) {
            if (tasksList[i].freelancerAddress == msg.sender) {
                resultCount++; 
            }
        }

        task[] memory tasks = new task[](resultCount);
        uint256 newIndex;

        for (uint i = 0; i < numberOfTasks; ++i) {
            if (tasksList[i].freelancerAddress == msg.sender) {
                tasks[newIndex] = tasksList[i];
                newIndex++;
            }
        }

        return tasks;
    }

    function markTaskAsDone(uint256 _taskId) public onlyFreelancer returns (string memory) {
        for (uint256 i = 0; i < numberOfTasks; ++i) {
            if (tasksList[i].id == _taskId) {
                require(tasksList[i].state == TaskState.WorkInProgress, "[Marketplace] The task must be in WorkInProgress state.");
                require(tasksList[i].freelancerAddress == msg.sender, "[Marketplace] This task is not yours.");

                tasksList[i].state = TaskState.Done;
                return "[Marketplace] The task was marked as done.";
            }
        }

        return "[Marketplace] The task was not found.";
    }

    function acceptTaskByManager(uint256 _taskId) public onlyManager returns (string memory) {
        for (uint256 i = 0; i < numberOfTasks; ++i) {
            if (tasksList[i].id == _taskId) {
                require(tasksList[i].managerAddress == msg.sender, "[Marketplace] This task is not yours.");
                require(tasksList[i].state == TaskState.Done, "[Marketplace] The task must be in Done state.");

                uint256 totalRewardForFreelancer = tasksList[i].currentFunds + tasksList[i].assessorReward;
                token.transfer(tasksList[i].freelancerAddress, totalRewardForFreelancer);

                if (freelancers[tasksList[i].freelancerAddress].reputation < MAX_REPUTATION) {
                    freelancers[tasksList[i].freelancerAddress].reputation += 1;
                }

                tasksList[i].state = TaskState.Success;

                return "[Marketplace] The task was accepted.";
            }
        }

        return "[Marketplace] The task was not found.";
    }

    function declineTaskByManager(uint256 _taskId) public onlyManager returns (string memory) {
        for (uint256 i = 0; i < numberOfTasks; ++i) {
            if (tasksList[i].id == _taskId) {
                require(tasksList[i].managerAddress == msg.sender, "[Marketplace] This task is not yours.");
                require(tasksList[i].state == TaskState.Done, "[Marketplace] The task must be in Done state.");

                tasksList[i].state = TaskState.NeedsArbitration;

                return "[Marketplace] The task was declined.";
            }
        }

        return "[Marketplace] The task was not found.";
    }

    function acceptTaskByAssessor(uint256 _taskId) public onlyAssessor returns (string memory) {
        for (uint256 i = 0; i < numberOfTasks; ++i) {
            if (tasksList[i].id == _taskId) {
                require(tasksList[i].assessorAddress == msg.sender, "[Marketplace] This task is not yours.");
                require(tasksList[i].state == TaskState.NeedsArbitration, "[Marketplace] The task must be in NeedsArbitration state.");

                token.transfer(tasksList[i].freelancerAddress, tasksList[i].currentFunds);

                if (freelancers[tasksList[i].freelancerAddress].reputation < MAX_REPUTATION) {
                    freelancers[tasksList[i].freelancerAddress].reputation += 1;
                }

                token.transfer(msg.sender, tasksList[i].assessorReward);

                tasksList[i].state = TaskState.Success;

                return "[Marketplace] The task was accepted.";
            }
        }

        return "[Marketplace] The task was not found.";
    }

    function declineTaskByAssessor(uint256 _taskId) public onlyAssessor returns (string memory) {
        for (uint256 i = 0; i < numberOfTasks; ++i) {
            if (tasksList[i].id == _taskId) {
                require(tasksList[i].assessorAddress == msg.sender, "[Marketplace] This task is not yours.");
                require(tasksList[i].state == TaskState.NeedsArbitration, "[Marketplace] The task must be in NeedsArbitration state.");

                returnContributionsForTask(_taskId);

                if (freelancers[tasksList[i].freelancerAddress].reputation > MIN_REPUTATION) {
                    freelancers[tasksList[i].freelancerAddress].reputation -= 1;
                }

                token.transfer(msg.sender, tasksList[i].assessorReward);

                tasksList[i].state = TaskState.Failed;

                return "[Marketplace] The task was declined.";
            }
        }

        return "[Marketplace] The task was not found.";
    }
}