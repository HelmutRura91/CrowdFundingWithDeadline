let CrowdFundingWithDeadline = artifacts.require //importing SC
('./TestCrowdFundingWithDeadline')

contract('CrowdFundingWithDeadline', function (accounts) {
    //fields
    let contract; //reference to SC
    let contract1;
    let contractCreator = accounts[0]; //address that will deploy SC
    let beneficiary = accounts[1];// address of beneficiary 

    const ONE_ETH = '1000000000000000000'; 

    const ONGOING_STATE = '0';
    const FAILED_STATE = '1';
    const SUCCEEDED_STATE = '2';
    const PAID_OUT_STATE = '3';

    //deploying an instance of SC in test environment
    beforeEach(async function(){ //beforeEach -> before every 'it' it is initialized and it erases all the values
        contract = await CrowdFundingWithDeadline.new( //using the object of our SC and calling the 'new' method
            //we need to provide 4 parameters
            'funding', //contract name
            1, //target amount
            10, //duration in time
            beneficiary, //ben. address
            //we have to provide two more parameters 
            {
                from: contractCreator, //address of an account that will deploy this Sc 
                gas: 2000000 //max amount of gas that we are willing to pay to deploy SC
            }
        

        );
        console.log(accounts);
            
    });
    //first test
    it('contract is initialized', async function(){ //checking if all the fields in this SC were initialized correctly
        let address = await contract.checkAddress.call();
        console.log(address)
        
        let campaignName = await contract.name.call() //checking if the campaignName is the one we passed in the constructor using 'call' mechanism and providing name of our field 'name'
        expect(campaignName).to.equal('funding');

        let targetAmount = await contract.targetAmount.call()
        console.log(targetAmount)
        expect(targetAmount.toString()).to.equal(ONE_ETH);//converting targetAmount to JavaScript number and then verify value using the constance that we provided

        let fundingDeadLine = await contract.fundingDeadLine.call()
        expect(fundingDeadLine.toNumber()).to.equal(600)

        let actualBeneficiary = await contract.beneficiary.call()
        console.log(beneficiary)
        console.log(actualBeneficiary)
        expect(actualBeneficiary).to.equal(beneficiary);

        let state = await contract.state.call()
        console.log(state)
        //Truffle contract returns from enum field -> an object, which has the valueOf method, which is a string that contains the position of the enum vaule in the enum definition
        expect(state.valueOf().toString()).to.equal(ONGOING_STATE);

    });

    it('funds are contributed', async function(){
       await contract.contribute({ //execute the contribute method and send 1 ethet with this method, need to specif an account from which to send this transaction 
        value: ONE_ETH,
        from: contractCreator
        });
        //cheching if SC has recorded that the contract creator has contributed 1 Ether
        let contributed = await contract.amounts //using amounts method because amounts is a public field
            .call(contractCreator);//for types like Boolean or uint solidity generates a getter that returns the value of this variable, but for mpping solidity generates a method that has one parameter which is the key in this map (12 line in contract)
            //and the method that was generated by solidity will return a value for this key
        expect(contributed.toString()).to.equal(ONE_ETH);
        //we called the generatedAmounts method and passed the key in this amounts map and then we check that the contract creator has contributed 1 Ether
        let totalCollected = await contract.totalCollected.call()
        expect(totalCollected.toString()).to.equal(ONE_ETH);

    })

})