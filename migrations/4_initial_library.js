var A = artifacts.require("A");
var C = artifacts.require("C");

module.exports = function(deployer) {
    deployer.deploy(A);
	deployer.link(A, C);
	deployer.deploy(C);
}
