pragma solidity ^0.4.24;

contract B {
	uint256 public x = 222;

    function b1(uint256 _value) public returns (uint256);

	function sum(uint256 _value) public pure returns (uint256) {
	    return _value * 2;
	}
}
