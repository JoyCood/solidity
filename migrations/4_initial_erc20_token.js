var TokenERC20 = artifacts.require("TokenERC20");

module.exports = function(deployer) {
    deployer.deploy(TokenERC20, 80000000, 'Pocket Token', 'PT');
}
