let Utils = artifacts.require("./Utils.sol"); //importing the library
let CrowdFundingWithDeadline = artifacts.require("./CrowdFundingWithDeadline.sol"); //importing two SC that we use in this project
let TestCrowdFundingWithDeadline = artifacts.require("./TestCrowdFundingWithDeadline.sol");

module.exports = async function(deployer){
        await deployer.deploy(Utils);
        deployer.link(Utils, CrowdFundingWithDeadline);
        deployer.link(Utils, TestCrowdFundingWithDeadline);
    }