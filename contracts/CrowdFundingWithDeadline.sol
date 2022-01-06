// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract CrowdFundingWithDeadline {
    enum State { Ongoing, Failed, Succeeded, PaidOut} //list of possible states

    string public name; //name of campaign, a string
    uint public targetAmount; //target amount in weis, to be successfull
    uint public fundingDeadLine; //uint, which represents number of seconds fromm January 1, 1970
    address public beneficiary;
    State public state;
    mapping(address => uint) public amounts; //a map called amounts, that contains how much each address has contributed to a campaign
    bool public collected; //will be set to true once necessary amount is collected
    uint public totalCollected;
    //first 'modifier' keyword, then name of modifier 'inState', then single parameter 'expectedState'
    modifier inState(State expectedState){
        //body of modifier
        require(state == expectedState, "Invalid state"); //checking if the state is same as expected state, if not then error message
        _;//applying modifier to methods on SC, if this check is valid, then we need to execute the body of our method
    }  

    constructor(
        string memory contractName,
        uint targetAmountEth,
        uint durationInMin,
        address payable beneficiaryAddress
    )
        public 
    {
        name = contractName;
        targetAmount = targetAmountEth * 1 ether;
        fundingDeadLine = currentTime() + durationInMin * 1 minutes; //"currentTime" function is not defined, so we need to define it below 
        state = State.Ongoing;
        beneficiary = beneficiaryAddress;
    }

    function contribute() public payable inState(State.Ongoing){ //should be payable because users will call this method to send funds. Then we specify that this method can only be called if our contract is in the ongoing state 
        require(
            beforeDeadLine(),
            "No contributions after the deadline"
        );
        amounts[msg.sender] += msg.value; //update the value that a particular account has contributed, then use the address on the sender 'msg.sender' as the key and then increase this by the value that was contributed in this transaction
        totalCollected += msg.value; //increasing the totalCollected value
        if(totalCollected>=targetAmount){ //checking if we have already collected more then we need to 
            collected = true;
        } 
          
    } 

    function finishCrowdFunding() public inState(State.Ongoing){
        require(!beforeDeadLine(), "Cannot finish campaign before Deadline");
        if(!collected){
            state=State.Failed;
        } else {
               state= State.Succeeded;
        }
    }

    function collect() public inState(State.Succeeded){
        if(payable(beneficiary).send(totalCollected)){ //we are sending all the funds collected to the beneficiary and if the transaction succeeds then it is true and state will be changed to paidOut
            state = State.PaidOut;
        } else { //if the transaction is unsuccessful (i.e. beneficiary address is unvalid), state will be changed to failed
            state = State.Failed;
        }
    }

    function withdraw() public inState(State.Failed){ //the only method we can call in Failed state, it allows to get a refund for contributing
        require(amounts[msg.sender] > 0, "Nothing was contributed"); //checking if particular user contributed to campaign
        uint contributed = amounts[msg.sender]; //get amount of funds that this particular user has contributed
        amounts[msg.sender] = 0; //changing the value that was contributed by this user to 0

        if (!payable(msg.sender).send(contributed)){ //sending contributed amount to the user
            amounts[msg.sender] = contributed; //if the transaction failes, we revert the change in amounts map and restore the value that was associated with this contributor
        }
    }
            
    function checkAddress() public view returns (address){
        return address(this); //'this' keyword 
    }

    function beforeDeadLine() public view returns(bool){
        return currentTime() < fundingDeadLine;
    }

    function currentTime() internal virtual view returns(uint){ //definig currentTime function
        return block.timestamp;
    }
}    
