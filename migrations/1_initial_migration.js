const Migrations = artifacts.require("Migrations");

var Migrations = artifacts.require("./Migrations.sol");
// var myContract = artifacts.require("./<source-file.sol>");

module.exports = function(deployer) {
  deployer.deploy(Migrations);
  // deployer.deploy(myContract, ..)  // If your contract uses
								   // any constructor parameters,
								   // pass them here.
};
