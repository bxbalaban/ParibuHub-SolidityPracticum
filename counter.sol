// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract Counter{
    //Global variables for holding the values
    uint public count;

    //function to increase count value by 1
    function inc() external{
        count+=1;
    }

    //function to decrease count value by 1
    function dec() external{
        count-=1;
    }
}