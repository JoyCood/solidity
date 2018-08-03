pragma solidity 0.4.24;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../../contracts/contract/c1.sol";

contract TestTransaction {
    Transaction transaction = Transaction(DeployedAddresses.Transaction());
    function test_f1() public {
	    Assert.equal(uint(1), uint(1), "result should equal 1");
	}
}
