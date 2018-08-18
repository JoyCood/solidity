pragma solidity ^0.4.24;

import "./Inherit_B.sol";

/**
 * 参考资料: https://ethereum.stackexchange.com/questions/12920/what-does-the-keyword-super-in-solidity-do
 */

/**
 * 支持多继承
 *
 * 按继承顺序，相同的方法名，顺序靠后的合约会覆盖掉前面的合约方法:
 * 如果B与C有相同的方法，按如下的继承顺序，C中的函数会覆盖掉B中的方法
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

    //虽然方法名与Inherit_B中的b1(uint256)方法同名同参，但参数类型
	//不一样，不属于方法重写，所以不需要遵循方法重写规则
	function b1(bool _value) 
	    public
		pure
		returns (bool)
	{
	    return !_value;
	}
	    
	//实现抽象合约Inherit_C的c2()方法
	function c2()
	    public
		returns (uint256)
	{
        return c1(); //调用Inherit_C中的c1()方法,返回222
	}

	//如果去掉此方法的注释，c2()将会调用此方法返回123
	//函数重写，方法的可见性，读写权限,返回值必须与父合约方法一致
	/*
	function c1()
	    public
		pure
		returns (uint256)
	{
	    return 123;
	}
    */

	//虽然同名，但参数个数不同，不属于方法重写
	function c1(uint256 _value) 
	    public
		pure
		returns (uint256)
	{
	    return _value * 2;
	}
}
