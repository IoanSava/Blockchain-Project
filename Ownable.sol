// SPDX-License-Identifier: MIT

pragma solidity >= 0.8.0 <=0.8.7;

abstract contract Ownable {
    address private owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "[Ownable] Caller is not the owner");
        _;
    }
}