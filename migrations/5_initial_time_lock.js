var TokenERC20 = artifacts.require("TokenTimelock");

module.exports = function(deployer) {
    deployer.deploy(TokenERC20, '0x6edd251498eed3d024ac347a2c51768fe67a8506', '0x14CD5c014C56cd8464f871b0955Aa3B23EB78B5a', 1533099376);
}
