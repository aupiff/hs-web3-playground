var Example = artifacts.require("./Example.sol");

module.exports = function(deployer, network, accounts) {
  deployer.deploy(Example, {from: web3.eth.accounts[0]});
};
