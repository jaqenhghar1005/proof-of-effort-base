// version 2
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ProofOfEffort {

    string public name = "ProofOfEffortNFT";
    string public symbol = "POE";

    struct User {
        uint256 streak;
        uint256 lastCheckIn;
        uint256 xp;
    }

    mapping(address => User) public users;
    mapping(bytes32 => bool) public usedProofs;

    mapping(uint256 => address) public ownerOf;
    mapping(address => uint256) public balanceOf;
    mapping(uint256 => string) public tokenURI;

    uint256 public tokenId;
    uint256 public constant DAILY_XP = 10;

    string public baseURI;

    constructor(string memory _baseURI) {
        baseURI = _baseURI;
    }

    function checkIn(bytes32 proofHash) external {
        require(!usedProofs[proofHash], "Proof already used");

        User storage user = users[msg.sender];

        if (block.timestamp > user.lastCheckIn + 1 days) {
            if (block.timestamp <= user.lastCheckIn + 2 days) {
                user.streak += 1;
            } else {
                user.streak = 1;
            }
        }

        user.lastCheckIn = block.timestamp;
        user.xp += DAILY_XP;

        usedProofs[proofHash] = true;
    }

    function mintWeeklyNFT() external {
        User storage user = users[msg.sender];

        require(user.streak >= 5, "Not enough streak");

        tokenId++;
        ownerOf[tokenId] = msg.sender;
        balanceOf[msg.sender]++;

        tokenURI[tokenId] = baseURI;

        user.streak = 0;
    }

    function getUser(address _user) external view returns (uint256, uint256, uint256) {
        User memory u = users[_user];
        return (u.streak, u.lastCheckIn, u.xp);
    }
}
