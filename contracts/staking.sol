// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Staking {
    address public owner;
    uint public stakingPeriod;
    uint public totalRewards;
    IERC20 public stakedToken;

    mapping(address => uint) public stakedBalances;
    mapping(address => uint) public stakingStartTimes;

    constructor(uint _stakingPeriod, uint _totalRewards, address _stakedTokenAddress) {
        owner = msg.sender;
        stakingPeriod = _stakingPeriod;
        totalRewards = _totalRewards;
        stakedToken = IERC20(_stakedTokenAddress);
    }

    event Staked(address indexed user, uint amount);
    event Withdrawn(address indexed user, uint amount);

    function stake(uint _amount) public {
        require(_amount > 0, "Staking amount must be greater than 0");

        require(stakedToken.transferFrom(msg.sender, address(this), _amount), "Transfer failed");

        stakedBalances[msg.sender] += _amount;
        stakingStartTimes[msg.sender] = block.timestamp;

        emit Staked(msg.sender, _amount);
    }

    function calculateRewards(address _user) public view returns (uint) {
        uint timeStaked = block.timestamp - stakingStartTimes[_user];
        return (stakedBalances[_user] * timeStaked) / stakingPeriod;
    }

address[] public stakers;

function distributeRewards() public {
    require(msg.sender == owner, "Only the owner can distribute rewards");

    uint totalStakedAmount = 0;

    for (uint i = 0; i < stakers.length; i++) {
        address user = stakers[i];
        totalStakedAmount += stakedBalances[user];
    }

    require(totalStakedAmount > 0, "No rewards to distribute");

    for (uint i = 0; i < stakers.length; i++) {
        address user = stakers[i];
        uint userStakedAmount = stakedBalances[user];
        if (userStakedAmount > 0) {
            uint userReward = (userStakedAmount * totalRewards) / totalStakedAmount;
            stakedBalances[user] += userReward;
        }
    }
}

    function withdraw() public {
        require(stakedBalances[msg.sender] > 0, "No staked tokens to withdraw");

        uint rewards = calculateRewards(msg.sender);
        uint totalAmount = stakedBalances[msg.sender] + rewards;

        stakedBalances[msg.sender] = 0;
        stakingStartTimes[msg.sender] = 0;

        // Transfer tokens back to the user
        require(stakedToken.transfer(msg.sender, totalAmount), "Transfer failed");

        emit Withdrawn(msg.sender, totalAmount);
    }

    function getStakedBalance(address _user) public view returns (uint) {
        return stakedBalances[_user];
    }

    function getRewardsBalance(address _user) public view returns (uint) {
        return calculateRewards(_user);
    }
}