// SPDX-License-Identifier: MIT

pragma solidity >= 0.8.0 <=0.8.7;

contract Marketplace {
    uint256 DEFAULT_REPUTATION = 5;

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
        uint256 freelancerReward;
        uint256 assessorReward;
        string category;
        address managerAddress;
        uint256 currentFunds;
        TaskState state;
    }

    struct contributorContribution {
        address contributorAddress;
        uint256 contribution; 
    }

    modifier onlyManager() {
        require(IsManagerAddress(msg.sender), "[Marketplace] You are not a manager!");
        _;
    }

    modifier onlyContributor() {
        require(IsContributorAddress(msg.sender), "[Marketplace] You are not a contributor!");
        _;
    }

    constructor() {}

    function compareStrings(string memory str1, string memory str2) private pure returns (bool) {
        return (keccak256(abi.encodePacked((str1))) == keccak256(abi.encodePacked((str2))));
    }

    function IsManagerAddress(address _address) private view returns (bool) {
        uint256 numberOfManagers = managerAddresses.length;
        for (uint256 i = 0; i < numberOfManagers; ++i) {
            if(managerAddresses[i] == _address) {
                return true;
            }
        }
        return false;
    }

    function IsContributorAddress(address _address) private view returns (bool) {
        uint256 numberOfContributors = contributorAddresses.length;
        for (uint256 i = 0; i < numberOfContributors; ++i) {
            if(contributorAddresses[i] == _address) {
                return true;
            }
        }
        return false;
    }

    function createManager(string calldata _name) public returns (string memory) {
        managerVar = manager(_name);
        managers[msg.sender] = managerVar;
        managersList.push(managerVar);
        managerAddresses.push(msg.sender);
        return "[Marketplace] Manager created";
    }

    function createFreelancer(string calldata _name, string calldata _category) public returns (string memory) {
        freelancerVar = freelancer(_name, _category, DEFAULT_REPUTATION);
        freelancers[msg.sender] = freelancerVar;
        freelancersList.push(freelancerVar);
        return "[Marketplace] Freelancer created";
    }

    function getFreelancers() public view returns(freelancer[] memory) {
        return freelancersList;
    }

    function createAssessor(string calldata _name, string calldata _category) public returns (string memory) {
        assessorVar = assessor(_name, _category);
        assessors[msg.sender] = assessorVar;
        assessorsList.push(assessorVar);
        return "[Marketplace] Assessor created";
    }

    function getAssessors() public view returns(assessor[] memory) {
        return assessorsList;
    }

    function createContributor(string calldata _name) public returns (string memory) {
        contributorVar = contributor(_name);
        contributors[msg.sender] = contributorVar;
        contributorsList.push(contributorVar);
        contributorAddresses.push(msg.sender);
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

    function cancelTask (uint256 _taskId) public onlyManager returns (string memory) {
        for (uint256 i = 0; i < numberOfTasks; ++i) {
            if(tasksList[i].id == _taskId) {
                if (tasksList[i].state == TaskState.Financing) {
                    if(tasksList[i].managerAddress == msg.sender) {
                        tasksList[i].state = TaskState.Canceled;
                        // TODO: De returnat contributiile finantatorilor

                        return "The task was canceled.";
                    }
                    return "You can not cancel the task of another manager.";
                }
                return "The task must be in Financing state.";
            }
        }
        return "The task was not found.";   
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

    function createContributorContribution(address _contributorAddress, uint256 _contributorValue, uint256 _taskId) private {
        contributorContributionVar = contributorContribution(_contributorAddress, _contributorValue);
        tasksContributions[_taskId].push(contributorContributionVar);
    }

    function financeTask(uint256 _taskId) public payable onlyContributor returns (string memory) {
        require(msg.value > 0, "Invalid amount of ETH");
        
        for (uint256 i = 0; i < numberOfTasks; ++i) {
            if(tasksList[i].id == _taskId) {
                if (tasksList[i].state == TaskState.Financing) {
                    int256 contributorContributionIndex = getContributorContributionIndexForTask(msg.sender, _taskId);
                    if (contributorContributionIndex == -1) {
                        // The contributor has not contributed to this task, it creates a new contribution
                        createContributorContribution(msg.sender, msg.value, _taskId);
                    }
                    else {
                        // The contributor has already contributed to this task, it adds the funds to the previous contribution
                        tasksContributions[_taskId][uint256(contributorContributionIndex)].contribution += msg.value;
                    }

                    tasksList[i].currentFunds += msg.value;

                    uint256 fundingGoal = tasksList[i].freelancerReward + tasksList[i].assessorReward;
                    if (tasksList[i].currentFunds == fundingGoal) {
                        tasksList[i].state = TaskState.Financed;
                    }
                    return "We received your contribution.";
                }
                return "The task must be in Financing state."; 
            }
        }
        return "The task was not found.";
    }

    function withdrawFunds(uint256 _taskId) public payable onlyContributor returns (string memory) {
        require(msg.value > 0, "Invalid amount of ETH");
        uint256 fundsToWithdraw = msg.value;
        
        for (uint256 i = 0; i < numberOfTasks; ++i) {
            if(tasksList[i].id == _taskId) {
                if (tasksList[i].state == TaskState.Financing) {
                    int256 contributorContributionIndex = getContributorContributionIndexForTask(msg.sender, _taskId);
                    if (contributorContributionIndex == -1) {
                        // The contributor has not contributed to this task
                        return "You have not contributed to this task.";
                    }
                    else {
                        // The contributor has contributed to this task, he can withdraw only his funds
                        // Check if msg.value is greater than his contribution to this task
                        uint256 previousTaskContribution = tasksContributions[_taskId][uint256(contributorContributionIndex)].contribution;
                        if (previousTaskContribution < msg.value) {
                            fundsToWithdraw = previousTaskContribution;
                        }
                        tasksContributions[_taskId][uint256(contributorContributionIndex)].contribution -= fundsToWithdraw;
                    }

                    tasksList[i].currentFunds -= fundsToWithdraw;

                    return "Your contribution has been withdrawn.";
                }
                return "The task must be in Financing state."; 
            }
        }
        return "The task was not found.";
    }
}