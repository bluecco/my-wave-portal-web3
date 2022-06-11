// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {
    uint256 totalWaves;

    address[] usersWaved;

    mapping(address => uint256) waveByAddress;

    constructor() {
        console.log("Let's see how may people will say hi!");
    }

    function wave() public {
        totalWaves += 1;
        if (waveByAddress[msg.sender] == 0) {
            usersWaved.push(msg.sender);
        }
        waveByAddress[msg.sender] += 1;
        console.log("%s said hi!", msg.sender);
    }

    function getTotalWaves() public view returns (uint256) {
        console.log("We have %d total waves!", totalWaves);
        return totalWaves;
    }

    function getWavesByAddress() public view returns (uint256) {
        console.log(
            "%s said hi %d times!",
            msg.sender,
            waveByAddress[msg.sender]
        );
        return waveByAddress[msg.sender];
    }

    function getUniqueUsersCount() public view returns (uint256) {
        console.log("%d users said hi", usersWaved.length);
        return usersWaved.length;
    }
}
