pragma solidity ^0.4.24;

import "./Inherit_A.sol";

contract Inherit_D {
	Inherit_A a;
    
	//类型为合约类型的情况下，只要传进来的值是地址类型都是合法的，
	//不管这个地址指向什么东西，能正常编译通过，
	//只是这个地址有与被调用的方法即可，如下:
    constructor(Inherit_A _a)
	    public
	{
        a = _a;	
	}

    function d1()
	    public
		returns (uint256)
	{
	    return a.a1();
	}
}
