pragma solidity 0.4.24;

import './A.sol';
import './B.sol';

contract C {
    using A for B;
	B public b;

	constructor(B _b) public {
	    b = _b;
	}

	function c1(uint256 _value) public {
	    b.a1(_value);
	}
}
