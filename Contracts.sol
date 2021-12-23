// SPDX-License-Identifier: MIT

pragma solidity >= 0.8.0 <=0.8.7;

import "./Ownable.sol";

contract Marketplace is Ownable {
    uint16 DEFAULT_REPUTATION = 5;

    manager private managerVar;
    mapping (address => manager) private managers;

    freelancer private freelancerVar;
    mapping (address => freelancer) private freelancers;

    assessor private assessorVar;
    mapping (address => assessor) private assessors;

    contributor private contributorVar;
    mapping (address => contributor) private contributors;

    task private taskVar;
    uint16 private numberOfTasks;
    mapping (uint16 => task) private tasks;

    struct manager {
        string name;
    }

    struct freelancer {
        string name;
        string category;
        uint16 reputation;
    }

    struct assessor {
        string name;
        string category;
    }

    struct contributor {
        string name;
        uint16 numberOfTokens; // update after the implementation of token is done
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
        string description;
        uint16 freelancerReward;
        uint16 assessorReward;
        string category;
        address managerAddress;
        TaskState state;
    }

    constructor() {}

    function compareStrings(string memory str1, string memory str2) pure private returns (bool) {
        return (keccak256(abi.encodePacked((str1))) == keccak256(abi.encodePacked((str2))));
    }

    function createManager(string calldata _name) public returns (string memory) {
        managerVar = manager(_name);
        managers[msg.sender] = managerVar;
        return "[Marketplace] Manager created";
    }

    function createFreelancer(string calldata _name, string calldata _category) public returns (string memory) {
        freelancerVar = freelancer(_name, _category, DEFAULT_REPUTATION);
        freelancers[msg.sender] = freelancerVar;
        return "[Marketplace] Freelancer created";
    }

    function createAssessor(string calldata _name, string calldata _category) public returns (string memory) {
        assessorVar = assessor(_name, _category);
        assessors[msg.sender] = assessorVar;
        return "[Marketplace] Assessor created";
    }

    function createContributor(string calldata _name, uint16 _numberOfTokens) public returns (string memory) {
        contributorVar = contributor(_name, _numberOfTokens);
        contributors[msg.sender] = contributorVar;
        return "[Marketplace] Contributor created";
    }

    function createTask(string calldata _description, uint16 _freelancerReward, uint16 _assessorReward, string calldata _category) public returns (string memory) {
        taskVar = task(_description, _freelancerReward, _assessorReward, _category, msg.sender, TaskState.Financing);
        tasks[numberOfTasks++] = taskVar;
        return "[Marketplace] Task created";
    }
}