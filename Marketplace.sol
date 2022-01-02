// SPDX-License-Identifier: MIT

pragma solidity >= 0.8.0 <= 0.8.7;

import "./Token.sol";

contract Marketplace {
    uint256 private DEFAULT_REPUTATION = 5;
    uint256 private TOKENS_INITIAL_SUPPLY = 1000;

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

    mapping(uint256 => address[]) tasksFreelancers;
    
    struct manager {
        string name;
    }

    struct freelancer {
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

    constructor(
        address _managerAddress,
        address _firstContributorAddress,
        address _secondContributorAddress,
        address _firstAssessorAddress,
        address _secondAssessorAddress,
        address _firstFreelancerAddress,
        address _secondFreelancerAddress
    ) {
        token = new Token(TOKENS_INITIAL_SUPPLY);
        emit TokenCreated(address(token));

        createManager("George", _managerAddress);

        createContributor("John", _firstContributorAddress);
        token.transfer(_firstContributorAddress, TOKENS_INITIAL_SUPPLY / 4);

        createContributor("Mike", _secondContributorAddress);
        token.transfer(_secondContributorAddress, TOKENS_INITIAL_SUPPLY / 4);

        createAssessor("Rihanna", "web", _firstAssessorAddress);
        createAssessor("Joe", "mobile", _secondAssessorAddress);

        createFreelancer("Andres", "web", _firstFreelancerAddress);
        token.transfer(_firstFreelancerAddress, TOKENS_INITIAL_SUPPLY / 4);

        createFreelancer("Kamila", "mobile", _secondFreelancerAddress);
        token.transfer(_secondFreelancerAddress, TOKENS_INITIAL_SUPPLY / 4);
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
        freelancerVar = freelancer(_name, _category, DEFAULT_REPUTATION);
        freelancers[_address] = freelancerVar;
        freelancerAddresses[_address] = true;
        return "[Marketplace] Freelancer created";
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
        taskVar = task(numberOfTasks, _description, _freelancerReward, _assessorReward, _category, msg.sender, address(0), 0, TaskState.Financing);
        tasksList.push(taskVar);
        return "[Marketplace] Task created";
    }

    function getTasks() public view returns(task[] memory) {
        return tasksList;
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

    function getContributorContributionIndexForTask(address _contributorAddress, uint256 _taskId) private view returns(int256) {
        uint256 numberOfContributions = tasksContributions[_taskId].length;
        for (uint256 i = 0; i < numberOfContributions; ++i) {
            if (tasksContributions[_taskId][i].contributorAddress == _contributorAddress) {
                return int(i);
            }
        }
        return -1;
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

    function doesFreelancerAlreadyAppliedForTask(address _freelancerAddress, uint256 _taskId) private view returns (bool) {
        uint256 numberOfApplications = tasksFreelancers[_taskId].length;
        for (uint256 i = 0; i < numberOfApplications; ++i) {
            if (tasksFreelancers[_taskId][i] == _freelancerAddress) {
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
                require(!doesFreelancerAlreadyAppliedForTask(msg.sender, _taskId), "[Marketplace] You already applied for this task");
            
                tasksFreelancers[_taskId].push(msg.sender);
                bool sent = token.transferFrom(msg.sender, address(this), tasksList[i].assessorReward);
                require(sent, "[Marketplace] Failed to transfer tokens to marketplace");

                return "[Marketplace] We received your application.";
            }
        }
        return "[Marketplace] The task was not found.";
    }

    function getApplicationsForTask(uint256 _taskId) public view returns(address[] memory) {
        return tasksFreelancers[_taskId];
    }
}