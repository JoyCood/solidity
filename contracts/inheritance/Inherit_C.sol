pragma solidity ^0.4.24;

contract Inherit_C {

	function c1() 
	    public
		returns (uint256) 
	{
        return 222;	
	}

	function c2() public returns (uint256);

	/**
	 * 如果去掉此行注释，Inherit_A将不能编译
	 * 因为未实现此抽像合约的所有抽像方法的合约
	 * 都是抽象合约，抽象合约是不能编译的
	 */
	//function c3() public returns (uint256);
}
