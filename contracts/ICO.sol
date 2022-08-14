// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "hardhat/console.sol";

contract ICO is Ownable {
    bool icoStarted = false;
    uint256 public startDate; 
    uint public endDate; 
    IERC20 token;
    uint public Rewards = 5000000;
    mapping(address => bool) public whitelist;
    mapping (address => uint) public rewards;
    uint public tokenPrice = 20000000000000000 wei;
    address payable DAO_Address;

    constructor(IERC20 _token, address payable _daoAddress) {
        token = _token;
        DAO_Address = _daoAddress;
    }

    // Make sure the ICO has started and is not finished
    modifier icoInProgress {
        require(icoStarted, "Ico has not started");
        require(block.timestamp > startDate, "ICO has not started");
        require(block.timestamp < endDate, "ICO has ended");
        _;
    }

    // Start the ICO sale 
    // @params - lenght of how long the sale should last
    function startICO(uint lengthOfSale) public onlyOwner {
        startDate = block.timestamp + (lengthOfSale * 86400); // Add by days
        endDate = startDate + (lengthOfSale * 86400); // Add by days
        icoStarted = true;
    }

    // Get Contract Balance of Hive Token
    function getTokenBalance() public view returns (uint) {
        return token.balanceOf(address(this));
    }

    function joinWhiteList() public icoInProgress {
        require(whitelist[msg.sender] == false, "Already on whitelist");
        whitelist[msg.sender] = true;
    }

    // Join the whitelist and credit rewards to the referer
    function joinWhiteListWithReferer(address referer) public icoInProgress {
        require(whitelist[msg.sender] == false, "Already on whitelist");

        if(msg.sender != referer) {
            if(Rewards >= 500) {
                rewards[referer] += 500;
                Rewards -= 500;
            }
            
            joinWhiteList();
        }
    }

    // Purchase tokens 
    // @params - amount of tokens to purchase
    function purchaseTokens(uint amount) public payable icoInProgress {
        require(whitelist[msg.sender], "User is not on the whitelist");
        uint tokensLeft = getTokenBalance();
        require(tokensLeft > (amount * 10 ** 18), "There are not enough tokens left");
        uint purchasePrice = tokenPrice * amount;
        require(msg.value >= purchasePrice, "Not enough eth to purchase that many tokens");

        // Send Hive Tokens
        uint credits = rewards[address(msg.sender)];
        uint totalTokens = (amount * 10 ** 18) + (credits * 10 ** 18);
        token.transfer(msg.sender, totalTokens);

        // Send Eth to the DAO
        DAO_Address.transfer(msg.value);
    }



}