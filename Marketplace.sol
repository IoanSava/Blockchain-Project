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
    manager[] private managersList;
    address[] private managerAddresses;

    freelancer private freelancerVar;
    mapping (address => freelancer) private freelancers;
    freelancer[] private freelancersList;

    assessor private assessorVar;
    mapping (address => assessor) private assessors;
    assessor[] private assessorsList;

    contributor private contributorVar;
    mapping (address => contributor) private contributors;
    contributor[] private contributorsList;
    address[] private contributorAddresses;

    task private taskVar;
    uint256 private numberOfTasks;
    mapping (uint256 => task) private tasks;
    task[] private tasksList;

    contributorContribution private contributorContributionVar;
    mapping(uint256 => contributorContribution[]) tasksContributions;
    
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
        uint256 currentFunds; // number of tokens
        TaskState state;
    }

    struct contributorContribution {
        address contributorAddress;
        uint256 contribution; // number of tokens
    }

    modifier onlyManager() {
        require(IsManagerAddress(msg.sender), "[Marketplace] You are not a manager!");
        _;
    }

    modifier onlyContributor() {
        require(IsContributorAddress(msg.sender), "[Marketplace] You are not a contributor!");
        _;
    }

    constructor(
        address _managerAddress,
        address _firstContributorAddress,
        address _secondContributorAddress
    ) {
        token = new Token(TOKENS_INITIAL_SUPPLY);
        emit TokenCreated(address(token));

        createManager("George", _managerAddress);

        createContributor("John", _firstContributorAddress);
        token.transfer(_firstContributorAddress, TOKENS_INITIAL_SUPPLY / 2);

        createContributor("Mike", _secondContributorAddress);
        token.transfer(_secondContributorAddress, TOKENS_INITIAL_SUPPLY / 2);
    }

    function compareStrings(string memory str1, string memory str2) private pure returns (bool) {
        return (keccak256(abi.encodePacked((str1))) == keccak256(abi.encodePacked((str2))));
    }

    function IsManagerAddress(address _address) private view returns (bool) {
        uint256 numberOfManagers = managerAddresses.length;
        for (uint256 i = 0; i < numberOfManagers; ++i) {
            if (managerAddresses[i] == _address) {
                return true;
            }
        }
        return false;
    }

    function IsContributorAddress(address _address) private view returns (bool) {
        uint256 numberOfContributors = contributorAddresses.length;
        for (uint256 i = 0; i < numberOfContributors; ++i) {
            if (contributorAddresses[i] == _address) {
                return true;
            }
        }
        return false;
    }

    function createManager(string memory _name, address _address) private returns (string memory) {
        managerVar = manager(_name);
        managers[_address] = managerVar;
        managersList.push(managerVar);
        managerAddresses.push(_address);
        return "[Marketplace] Manager created";
    }

    function createFreelancer(string memory _name, string memory _category, address _address) private returns (string memory) {
        freelancerVar = freelancer(_name, _category, DEFAULT_REPUTATION);
        freelancers[_address] = freelancerVar;
        freelancersList.push(freelancerVar);
        return "[Marketplace] Freelancer created";
    }

    function getFreelancers() public view returns(freelancer[] memory) {
        return freelancersList;
    }

    function createAssessor(string memory _name, string memory _category, address _address) private returns (string memory) {
        assessorVar = assessor(_name, _category);
        assessors[_address] = assessorVar;
        assessorsList.push(assessorVar);
        return "[Marketplace] Assessor created";
    }

    function getAssessors() public view returns(assessor[] memory) {
        return assessorsList;
    }

    function createContributor(string memory _name, address _address) private returns (string memory) {
        contributorVar = contributor(_name);
        contributors[_address] = contributorVar;
        contributorsList.push(contributorVar);
        contributorAddresses.push(_address);
        return "[Marketplace] Contributor created";
    }

    function createTask(string calldata _description, uint256 _freelancerReward, uint256 _assessorReward, string calldata _category) public onlyManager returns (string memory) {
        taskVar = task(numberOfTasks, _description, _freelancerReward, _assessorReward, _category, msg.sender, 0, TaskState.Financing);
        tasks[numberOfTasks] = taskVar;
        numberOfTasks++;
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

    function getFinancingTasks() public view returns(task[] memory) {
        uint256 resultCount;
        for (uint256 i = 0; i < numberOfTasks; ++i) {
            if (tasksList[i].state == TaskState.Financing) {
                resultCount++; 
            }
        }

        task[] memory financingTasksList = new task[](resultCount);
        uint256 newIndex;

        for (uint i = 0; i < numberOfTasks; ++i) {
            if (tasksList[i].state == TaskState.Financing) {
                financingTasksList[newIndex] = tasksList[i];
                newIndex++;
            }
        }
        return financingTasksList;
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

    function financeTask(uint256 _taskId, uint256 tokenAmount) external onlyContributor returns (string memory) {
        require(tokenAmount > 0, "[Marketplace] Invalid amount of tokens");
        uint256 tokenBalance = token.balanceOf(msg.sender);
        require(tokenBalance >= tokenAmount, "[Marketplace] You don't have enough tokens");
        
        for (uint256 i = 0; i < numberOfTasks; ++i) {
            if (tasksList[i].id == _taskId) {
                require(tasksList[i].state == TaskState.Financing, "[Marketplace] The task must be in Financing state.");
                
                bool sent = token.transferFrom(msg.sender, address(this), tokenAmount);
                require(sent, "[Marketplace] Failed to transfer tokens to marketplace");

                int256 contributorContributionIndex = getContributorContributionIndexForTask(msg.sender, _taskId);
                if (contributorContributionIndex == -1) {
                    createContributorContribution(msg.sender, tokenAmount, _taskId);
                }
                else {
                    tasksContributions[_taskId][uint256(contributorContributionIndex)].contribution += tokenAmount;
                }

                tasksList[i].currentFunds += tokenAmount;
                uint256 fundingGoal = tasksList[i].freelancerReward + tasksList[i].assessorReward;
                if (tasksList[i].currentFunds >= fundingGoal) {
                    tasksList[i].state = TaskState.Financed;
                }

                return "[Marketplace] We received your contribution.";
            }
        }
        return "[Marketplace] The task was not found.";
    }
}