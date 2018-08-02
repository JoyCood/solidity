var Transaction = artifacts.require("Transaction");

module.exports = function(deployer) {
    deployer.deploy(Transaction, '0x8d5b7b8a61c37334c890c9f8e7ab212f531292b9');
}
