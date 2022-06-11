// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {
    uint256 totalWaves;

    address[] usersWaved;

    mapping(address => uint256) wavesByAddress;

    event NewWave(address indexed from, uint256 timestamp, string message);

    struct Wave {
        address waver;
        string message;
        uint256 timestamp;
    }

    Wave[] waves;

    uint256 private successRoll;
    mapping(address => uint256) public cooldown;

    constructor() payable {
        console.log("Let's see how may people will say hi!");
        successRoll = (block.timestamp + block.difficulty) % 100;
    }

    function wave(string memory _message) public {
        require(
            cooldown[msg.sender] + 15 minutes < block.timestamp,
            "cd for action is 15 minutes"
        );

        cooldown[msg.sender] = block.timestamp;

        totalWaves += 1;
        if (wavesByAddress[msg.sender] == 0) {
            usersWaved.push(msg.sender);
        }
        wavesByAddress[msg.sender] += 1;
        waves.push(Wave(msg.sender, _message, block.timestamp));
        console.log("%s waved with message %s", msg.sender, _message);

        successRoll = (block.difficulty + block.timestamp + successRoll) % 100;
        console.log("Random # generated: %d", successRoll);
        if (successRoll <= 50) {
            console.log("%s won!", msg.sender);
            uint256 prizeAmount = 0.0001 ether;
            require(
                prizeAmount <= address(this).balance,
                "Trying to withdraw more money than the contract has."
            );
            (bool success, ) = (msg.sender).call{value: prizeAmount}("");
            require(success, "Failed to withdraw money from contract.");
        }

        emit NewWave(msg.sender, block.timestamp, _message);
    }

    function getTotalWaves() public view returns (uint256) {
        console.log("We have %d total waves!", totalWaves);
        return totalWaves;
    }

    function getWavesByAddress() public view returns (uint256) {
        console.log(
            "%s said hi %d times!",
            msg.sender,
            wavesByAddress[msg.sender]
        );
        return wavesByAddress[msg.sender];
    }

    function getUniqueUsersCount() public view returns (uint256) {
        console.log("%d users said hi", usersWaved.length);
        return usersWaved.length;
    }

    function getAllWaves() public view returns (Wave[] memory) {
        return waves;
    }
}
