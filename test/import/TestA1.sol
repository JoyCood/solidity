pragma solidity 0.4.24;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../../contracts/import/A1.sol";

contract TestA1 {
    A1 a = A1(DeployedAddresses.A1());

	function test_x() public {
        uint256 result = a.x();	
		Assert.equal(8, result, 'result should be equal 8');
	}
}
