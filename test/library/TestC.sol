pragma solidity 0.4.24;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../../contracts/library/C.sol";

contract TestC {
    C c = C(DeployedAddresses.C());

	function test_c1() public {
        uint256 result = c.c1();	
		Assert.equal(4, result, "result should equal 4");
	}

	function test_c2() public {
	    uint256 result = c.c2();
		Assert.equal(2, result, "result should equal 2");
	}

	function test_c3() public {
	    bool result = c.c3();
		Assert.equal(false, result, 'result should equal false');
	}
}
