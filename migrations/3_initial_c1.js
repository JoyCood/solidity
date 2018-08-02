var Transaction = artifacts.require("Transaction");

module.exports = function(deployer) {
    deployer.deploy(Transaction, '0x4dc87a1ae69664b48a02cb1191589aa5f1b561c2');
}
