pragma solidity ^0.4.24;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../../contracts/inheritance/Inherit_A.sol";

contract TestInherit_A {
    Inherit_A a = Inherit_A(DeployedAddresses.Inherit_A());

	function test_b1() public {
        uint256 result = a.b1();	
		Assert.equal(88, result, 'result should be equal 88');
	}
}
