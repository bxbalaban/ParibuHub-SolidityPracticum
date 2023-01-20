// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract FeeCollector{

    address public owner;
    uint256 public balance;

    constructor(){
        owner=msg.sender;
    }

    receive() payable external{
        balance+=msg.value;
    }

    function withdraw (uint amount, address payable destAddr) public{
        //security added so only owner can withdraw
        require(msg.sender == owner, "only owner can withdraw"); 

        //checking the balance and sufficient amount
        require(amount <= balance, "Insufficient funds");
        
        destAddr.transfer(amount);
        balance-=amount;
    }
}
