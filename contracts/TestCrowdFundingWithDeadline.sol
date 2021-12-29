// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
import "./CrowdFundingWithDeadline.sol";
//we create this test SC so we can set the current time for tests purposes, thsi will be the only differance between production SC
contract TestCrowdFundingWithDeadline is CrowdFundingWithDeadline{ //test contract inherits the prod. sc that we've created
    uint time; //creating variable with time
    //we need to initialize fields, so we provide contructor, it has the same parametrs and all it does is it calls the contructor from the parent contract and just passess all the parameters to the parent contract constructor
    constructor(
       string memory contractName,
        uint targetAmountEth,
        uint durationInMin,
        address beneficiaryAddress 
    )

        CrowdFundingWithDeadline(contractName, targetAmountEth, durationInMin, beneficiaryAddress)
        public 
    {

    }
    
    //redefining current time method that will take the value of 'time' variable 
    function currentTime() internal override view returns(uint){ //currentTime is internal, we dont need to call thsi from outside of SC, but SC will rely on this method to get current time
        return time;
    }
//for test we need to have abillity to set current time, se we implement simple setter for this variable,
    function setCurrentTime(uint newTime) public{ //this setter is public, because we need to ba able to call this from outside of SC,
        time = newTime;
    }
}