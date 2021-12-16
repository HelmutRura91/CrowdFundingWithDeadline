let CrowdFundingWithDeadline = artifacts.require //importing SC
('./CrowdFundingWithDeadline')

contract('CrowdFundingWithDeadline', function (accounts) {
    //fields
    let contract; //reference to SC
    let contractCreator = accounts[0]; //address that will deploy SC
    let beneficiary = '0x0000000000000000000000000000000000000000'; //accounts[1] //address of beneficiary ;

    const ONE_ETH = 1000000000000000//00n;

    const ONGOING_STATE = '0';
    const FAILED_STATE = '1';
    const SUCCEEDED_STATE = '2';
    const PAID_OUT_STATE = '3';

    //deploying an instance of SC in test environment
    beforeEach(async function(){
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
    });
    //first test
    it('contract is initialized', async function(){ //checking if all the fields in this SC were initialized correctly
        let campaignName = await contract.name.call() //checking if the campaignName is the one we passed in the constructor using 'call' mechanism and providing name of our field 'name'
        expect(campaignName).to.equal('funding');

        let targetAmount = await contract.targetAmount.call()
        expect(targetAmount.toNumber()).to.equal(ONE_ETH);//converting targetAmount to JavaScript number and then verify value using the constance that we provided

        let actualBeneficiary = await contract.beneficiary.call()
        expect(actualBeneficiary).to.equal(beneficiary);

        // let state = await contract.state.call()
        //Truffle contract returns from enum field -> an object, which has the valueOf method, which is a string that contains the position of the enum vaule in the enum definition
        // expect(state.valueOf()).to.equal(ONGOING_STATE);

    });
})