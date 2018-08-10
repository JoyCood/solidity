pragma solidity ^0.4.24;

contract Inherit_B {
	uint256 value = 10;

    /*
	析构函数不能带有returns语句
	constructor() public returns (uint256) {
        return 0;
    }
    */

	constructor(uint256 _value) public {
		value = _value; //设置的是本合约中的value状态变量
	}

	function b1()
	    public
	    view	
		returns (uint256)
	{
		//返回的是本合约中的value状态变量值，而非派生合约中的状态变量value的值
		return value; 
	}

	//函数重载返回值类型可以不一致，
	//函数可见性也可以不一致
	//相当于一个独立的函数
	function b1(uint256)
	    public
		pure
		returns (bool)
	{
	    return true;
	}
}
