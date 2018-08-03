pragma solidity ^0.4.23;

import "./A.sol";
//import "./B.sol";

contract C {
    using A for B;    
    B public b;

	uint256 public x = 1;
    address public contractAddress;
	uint256[] public value;

	event LogSender(bool equal);
	event LogValue(uint256 value);
	//event LogValue(bool equal); //事件支持重载 web3客户端不支持？

	constructor() public {
        contractAddress = this;    	
	}

	function c1() public view returns (uint256) {
		//b.a0(); //不允许调用library中private的函数
		b.a0_1(); //允许调用library中internal的函数
        return b.a1(2); 	
	} 

	function c2() public returns (uint256) {
        x = b.a2(x);	
		return x;
	}

    //检测library中的this关字键字是不是合约C的地址
	function c3() public view returns (bool) {
		return (b.a3() == contractAddress); //true
	}

	//检测library中的msg.sender是不是交易发起人的地址
	function c4() public returns (bool) {
		emit LogSender(b.a4() == msg.sender); //true
	    return (b.a4() == msg.sender);
	}

    //library 传值测试
	function c5() public returns (uint256) {
	    uint256[] memory _value = new uint256[](1);

		b.a5(_value); //调用library的函数，memory->memory是值copy传参
		//c5_1(value); //引用传参

		emit LogValue(_value[0]);
		return _value[0];
	}

    //引用传参
	function c5_1(uint256[] _value) internal pure {
	    _value[0] = 10;
	}

	function c6() public returns (uint256) {
		value.push(5);
        b.a6(value);
	    emit LogValue(value[0]);
	    return value[0];	
	}

	function c7() public returns (uint256) {
	    uint256 _value = b.a7(10);
		//uint256 _value = b.sum(2); //非法调用
		emit LogValue(_value);
		return _value;
	}

}
