// SPDX-License-Identifier: MIT

pragma solidity >=0.8.0 <=0.8.7;

contract Marketplace {
    address private admin;
    address payable private managerAddress;

    manager private managerVar;
    uint16 private numberOfManagers;
    mapping (address => manager) private managers;

    task private taskVar;
    uint16 private numberOfTasks;
    mapping (address => task) private tasks;

    freelancer private freelancerVar;
    uint16 private numberOfFreelancers;
    mapping (address => freelancer) private freelancers;

    assessor private assessorVar;
    uint16 private numberOfAssessors;
    mapping (address => assessor) private assessors;

    contributor private contributorVar;
    uint16 private numberOfContributors;
    mapping (address => contributor) private contributors;

    struct manager {
        string name;
        address managerAddress;
    }

    struct task {
        string description;
        uint16 freelancerReward;
        uint16 assessorReward;
        string taskCategory;
        address managerAddress;
    }

    struct freelancer {
        string freelancerName;
        string freelancerCategory;
        uint16 reputation;
        address freelancerAddress;
    }

    struct assessor {
        string assessorName;
        string assessorCategory;
        address assessorAddress;
    }

    struct contributor {
        string contributorName;
        uint16 numberOfTokens;
        address contributorAddress;
    }

    enum State {
        Creating,
        Financing,
        Closed
    }

    State state;

    
    constructor(address payable _managerAddress, string memory _name) {
        admin = msg.sender;
        managerAddress = _managerAddress;
        if (compareStrings(managers[payable(msg.sender)].name, "")) {
            managerVar = manager(_name, msg.sender);
            managers[msg.sender] = managerVar;
            ++numberOfManagers;
        }
        state = State.Creating;
        //     return "Manager created";
        // } else {
        //     return "This manager has already been created!";
        // }
    }

    modifier onlyByAdmin() {
        require(msg.sender == admin, "You're not an admin");
        _;
    }

    function compareStrings(string memory str1, string memory str2) pure private returns (bool) {
        return (keccak256(abi.encodePacked((str1))) == keccak256(abi.encodePacked((str2))));
    }


    // function createManager(string calldata _name) onlyByAdmin public returns (string memory) {
    //     if (compareStrings(managers[payable(msg.sender)].name, "")) {
    //         managerVar = manager(_name, msg.sender);
    //         managers[msg.sender] = managerVar;
    //         ++numberOfManagers;
    //         return "Manager created";
    //     } else {
    //         return "This manager has already been created!";
    //     }
    // }

    function createTask(address payable _managerAddress, string calldata _description, uint16 _freelancerReward, uint16 _assessorReward, string calldata _taskCategory) onlyByAdmin public returns (string memory) {
        require(state == State.Creating);
        if (compareStrings(tasks[payable(msg.sender)].description, "")) {
            taskVar = task(_description, _freelancerReward, _assessorReward, _taskCategory, _managerAddress);
            tasks[_managerAddress] = taskVar;
            ++numberOfTasks;
            state = State.Financing;
            return "Task created";
        } else {
            return "You already have created a task!";
        }
    }

    function getNumberOfTasks() public view returns (uint16) {
        return numberOfTasks;
    }

    function createFreelancer(string calldata _freelancerName, string calldata _freelancerCategory, address payable _freelancerAddress) public returns (string memory) {
        require(state == State.Financing);
        if (compareStrings(freelancers[payable(msg.sender)].freelancerName, "")) {
            freelancerVar = freelancer(_freelancerName, _freelancerCategory, 5, _freelancerAddress);
            freelancers[_freelancerAddress] = freelancerVar;
            ++numberOfFreelancers;
            return "Freelancer created";
        } else {
            return "The freelancer with this address already exists!";
        }
    }

    function getNumberOfFreelancers() public view returns (uint16) {
        return numberOfFreelancers;
    }

    function createAssessor(string calldata _assessorName, string calldata _assessorCategory, address payable _assessorAddress) public returns (string memory) {
        require(state == State.Financing);
        if (compareStrings(assessors[payable(msg.sender)].assessorName, "")) {
            assessorVar = assessor(_assessorName, _assessorCategory, _assessorAddress);
            assessors[_assessorAddress] = assessorVar;
            ++numberOfAssessors;
            return "Assessor created";
        } else {
            return "The assessor with this address already exists!";
        }
    }

    function getNumberOfAssessors() public view returns (uint16) {
        return numberOfAssessors;
    }

    function createContributor(string calldata _contributorName, uint16 _numberOfTokens, address payable _contributorAddress) public returns (string memory) {
        require(state == State.Financing);
        if (compareStrings(contributors[payable(msg.sender)].contributorName, "")) {
            contributorVar = contributor(_contributorName, _numberOfTokens, _contributorAddress);
            contributors[_contributorAddress] = contributorVar;
            ++numberOfContributors;
            return "Contributor created";
        } else {
            return "The contributor with this address already exists!";
        }
    }

    function getNumberOfContributors() public view returns (uint16) {
        return numberOfContributors;
    }

}

contract Manager {

}

contract Task {

}

contract Freelancer {

}

//Evaluator
contract Assessor {

}

//Finantator
contract Contributor {

}