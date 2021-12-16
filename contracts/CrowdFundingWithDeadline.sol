// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract CrowdFundingWithDeadline {
    enum State { Ongoing, Failed, Succeeded, PaidOut} //list of possible states

    string public name; //name of campaign, a string
    uint public targetAmount; //target amount in weis, to be successfull
    uint public fundingDeadLine; //uint, which represents number of seconds fromm January 1, 1970
    address public beneficiary;
    State public state;

    constructor(
        string memory contractName,
        uint targetAmountEth,
        uint durationInMin,
        address beneficiaryAddress
    )
        public 
    {
        name = contractName;
        targetAmount = targetAmountEth * 1000000000000000 wei;
        fundingDeadLine = currentTime() + durationInMin * 1 minutes; //"currentTime" function is not defined, so we need to define it below 
        state = State.Ongoing;
    }

    function currentTime() internal view returns(uint){ //definig currentTime function
        return block.timestamp;
    }
}
