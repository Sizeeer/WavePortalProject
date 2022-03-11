// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import "hardhat/console.sol";

contract WavePortal {
    event NewWave(address indexed from, uint256 timestamp, string message);

    uint256 private seed;

    uint256 totalWaves;
    mapping(address => address) vipAddreses;

    struct Wave {
        address waver;
        string message;
        uint256 timestamp;
    }

    Wave[] waves;

    mapping(address => uint256) lastWavedAt;

    constructor() payable {
        console.log("Yo yo, I am a contract and I am smart");

        seed = (block.timestamp + block.difficulty) % 100;
    }

    function wave(string memory _message) public {
        require(
            lastWavedAt[msg.sender] + 30 seconds < block.timestamp,
            "Wait 30 sec"
        );

        lastWavedAt[msg.sender] = block.timestamp;

        totalWaves += 1;
        console.log("%s has waved", msg.sender);

        waves.push(Wave(msg.sender, _message, block.timestamp));

        seed = (block.timestamp + block.difficulty) % 100;

        if (seed <= 50) {
            uint256 prizeAmount = 0.0001 ether;

            require(prizeAmount <= address(this).balance, "Small balance");

            (bool success, ) = (msg.sender).call{value: prizeAmount}("");
            require(success, "Failed to withdraw money from contract.");
        }

        emit NewWave(msg.sender, block.timestamp, _message);
    }

    function getAllWaves() public view returns (Wave[] memory) {
        return waves;
    }

    function getTotalWaves() public view returns (uint256) {
        console.log("We have %d total waves!", totalWaves);
        return totalWaves;
    }

    function addToVip(address _address) public {
        vipAddreses[_address] = _address;
        console.log("We have %d total waves!", _address);
    }

    function isVip() public view returns (bool) {
        if (vipAddreses[msg.sender] != address(0)) {
            return true;
        }
        return false;
    }
}
