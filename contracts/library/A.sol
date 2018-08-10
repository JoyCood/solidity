pragma solidity ^0.4.24;

import "./B.sol";

library A {
    //不允许声明状态变量
	//uint256 internal x; 

    //可以在library中声明状态常量
	uint8 constant y = 10;

    //允许声明新的数据类型
	struct Data { mapping(uint => bool) flags; } 

	//library不允许定义析构函数
	//constructor() public pure {}

	//
    function a0(B) private pure {}	

	function a0_1(B) internal pure {}

    function a1(B, uint256 _value) public pure returns (uint256) {
        return (_value * 2);
	}

	//修改合约状态变量
	function a2(B, uint256 _value) public pure returns (uint256) {
        //不允许通过这种方式访问调用方的状态变量
		//x = _value; 

        //也不允许这种方式访问调用方的状态变量
	    //address(this).x = _value; 

		//对于memory存储类型的参数，此处的修改无法影响到合约的状态变量值
		_value += 1;

		return _value; //调用方通过保存返回值进行修改状态变量的值
	}

	//调用方的合约地址
	function a3(B) public view returns (address) {
	    return this;     
	}

	function a4(B) public view returns (address) {
	    return msg.sender;
	}

	function a5(B, uint256[] memory _value) public pure {
        _value[0] = 8;	
	}

	//library中的public函数参数可以为storage，
	//在contract中不允许public的函数参数为storage
	//引用传参，此处的修改会影响调用方的状态变量
	function a6(B, uint256[] storage _value) public {
        _value[0] = 10;	
	}

	function a7(B, uint256 _value) public pure returns (uint256) {
	    //function a7(B _b, uint256 _value)
	    //return _b.sum(_value); //非法调用
	    return a7_1(_value);
	}

	function a7_1(uint256 _value) private pure returns (uint256){
	    return _value + 2;    
	}

	//library不允许有payable的函数
	//function a3(B) public payable {}

	//library不允许有匿名函数
	//function () {}

}
