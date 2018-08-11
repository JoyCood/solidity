pragma solidity ^0.4.24;

import "./Inherit_B.sol";

/**
 * 参考资料: https://ethereum.stackexchange.com/questions/12920/what-does-the-keyword-super-in-solidity-do
 */

contract Inherit_A is Inherit_B(88), Inherit_C {
    uint256 value = 55;

	function b1()
	    public
		view
		returns (uint256)
	{   
		/* 不能通过这种方式获取父合约的状态变量值 */
		//return super.value(); 

		/* 返回父合约中状态变量value的值:88 */
        //return Inherit_B.value;

		//请注意上方传给父合约析构函数的值：88
		//返回本合约的状态变量value=55
	    return value; 
	}

	//调用父类的方法示例
	function a1()
	    public
	    view	
		returns (uint256)
	{
	    return super.b1(); //返回父合约状态变量value的值:88
	}

	//调用父类的方法示例
	function a2()
	    public
		view
		returns (uint256)
	{
	    return Inherit_B.b1(); //返回父合约状态变量value的值: 88
	}

	//实现抽象合约Inherit_C的c2()方法
	function c2()
	    public
		returns (uint256)
	{
        return c1(); //调用Inherit_C中的c1()方法
	}
}
