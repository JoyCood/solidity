//require的是合约名称，不是文件名
var Basic = artifacts.require("Basic");

module.exports = function(deployer) {
    deployer.deploy(Basic, 1);
}
