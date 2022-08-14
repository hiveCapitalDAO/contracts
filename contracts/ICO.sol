// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "hardhat/console.sol";

contract ICO {
    uint256 public startDate; 
    uint  public endDate; 
    IERC20 token;
    uint public Rewards = 5000000;
    mapping(address => bool) public whitelist;
    mapping (address => uint) public rewards;

    constructor(uint daysTillState, uint lengthOfSale, IERC20 _token) {
        startDate = block.timestamp + (daysTillState * 86400); // Add by days
        endDate = startDate + (lengthOfSale * 86400); // Add by days
        token = _token;
    }

    // Get Contract Balance of Token
    function getTokenBalance() public view returns (uint) {
        return token.balanceOf(address(this));
    }

    function joinWhiteList() public {
        require(block.timestamp > startDate, "ICO has not started");
        require(block.timestamp < endDate, "ICO has ended");
        // If user is not on whitelist 
        if(!whitelist[msg.sender]) {
            whitelist[msg.sender] = true;
        }
    }

    // Join the whitelist and credit rewards to the referer
    function joinWhiteListWithReferer(address referer) public {
        require(block.timestamp > startDate, "ICO has not started");
        require(block.timestamp < endDate, "ICO has ended");

        if(msg.sender != referer) {
            if(Rewards > 0) {
                rewards[referer] += 500;
                Rewards -= 500;
            }
            
            joinWhiteList();
        }
    }

}