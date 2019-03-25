var SafeMath        = artifacts.require("./SafeMath.sol");
var ERC223          = artifacts.require("./ERC223.sol");


module.exports = function(deployer) {
  deployer.deploy(SafeMath);
  deployer.deploy(ERC223);
};
