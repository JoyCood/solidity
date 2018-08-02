pragma solidity ^0.4.24;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../../contracts/hello/Hello.sol";

contract TestHello {
	struct Person { //不能在这里预设struct类型的默认值
	    string name;
		string sex;
		uint8  age;
	}

    Hello hello = Hello(DeployedAddresses.Hello());

	function test_t1() public  {
	    uint result = hello.t1(1);
		Assert.equal(1, result, 'result should be equal 1');
	}

	function test_t2() public {
	    uint result = hello.t2();
		Assert.equal(1, result, 'result should be equal 1');
	}

	function test_t3() public {
	    int result = hello.t3(1);
		Assert.equal(2, result, 'result should be equal 2');
	}

	function test_t4() public {
	    uint result = hello.t4();
		Assert.equal(1, result, 'result should be equal 1');
	}

	function test_t5() public {
	    uint[] memory result = hello.t5();
		Assert.equal(102, result[2], 'result[2] should be equal 102');
	}

	function test_t6() public {
	    (int result1, string memory result2) = hello.t6();
		Assert.equal(1, result1, 'result1 should be equal 1');
		Assert.equal('second', result2, 'result2 should be equal `second`');

		int result3 = hello.t6(1);
		Assert.equal(1, result3, 'result3 should be equal 1');
		string memory result4 = hello.t6('four');
		Assert.equal('four', result4, 'result4 should be equal `four`');
	} 

	function test_t7() public {
	    uint result = hello.t7();
		Assert.equal(1, result, 'result should be equal 10');
	}

	function test_t8() public {
	    uint[4] memory result = hello.t8();
		Assert.equal(1, result[0], 'result[0] should be equal 1');
	    Assert.equal(2, result[1], 'result[1] should be equal 2');	
	}

	function test_t9() public {
	    uint[4] memory result = hello.t9();
	    Assert.equal(100, result[0], 'result[0] should be equal 100');	
		Assert.equal(300, result[3], 'result[3] should be equal 300');
	}

	function test_t10() public {
	    uint[4] memory result = hello.t10();
		Assert.equal(100, result[0], 'result[0] should be equal 100');
	}

	function test_t11() public {
	    uint[] memory result = hello.t11();
		Assert.equal(1, result[0], 'result[0] should be equal 1');
		Assert.equal(1, result[100], 'result[100] should be equal 1');
		Assert.equal(3, result[102], 'result[102] should be equal 3');

		Assert.equal(104, result.length, 'result length should be equal 104');
	}

    function test_t12() public {
	    uint[] memory result = hello.t12();
		Assert.equal(4, result[3], 'result[3] should be equal 1');
	}

	function test_t13() public {
	    (uint value, uint value2, uint value3, uint value4) = hello.t13();
		Assert.equal(1, value,  'value should be equal 1');
		Assert.equal(0, value2, 'value2 should be equal 0');
		Assert.equal(0, value3, 'value3 should be equal 0');
		Assert.equal(4, value4, 'value4 should be equal 4');
	}

	function test_t14() public {
        (uint[] memory result, uint[] memory result2) = hello.t14();
	    Assert.equal(2, result[0], 'result[0] should be equal 2');	
		Assert.equal(222, result2[0], 'result[0] should be equal 222');
	}

	function test_t15() public {
		uint result = hello.t15();
	    Assert.equal(100, result, 'result should be equal 100');
	}

	function test_t16() public {
	    (uint result, uint result2, uint result3) = hello.t16();
		Assert.equal(11, result, 'result should be equal 11');
		Assert.equal(30, result2, 'result2 should be equal 30');
		Assert.equal(210, result3, 'result3 should be equal 210');
	}

	function test_t17() public {
	    uint result = hello.t17();
		Assert.equal(2, result, 'result should be equal 2');
	}

	function test_t18() public {
		//合约外部调用，不支持返回嵌套数组
		//uint[5][] memory result = hello.t18(); 

	    uint result = hello.t18();
		Assert.equal(100, result , 'result should be equal 100');
	}

	function test_t19() public {
		//外部调用，不支持返回结构体
	    //Person memory result = hello.t19(); 
		uint result = hello.t19();
		Assert.equal(9, result, 'result should be equal 10');
	}

	function test_t20() public {
	    uint result = hello.t20();
		Assert.equal(10, result, 'result should be equal 10');
	}

	function test_t25() public {
        (uint result, uint result2) = hello.t25();
	    Assert.equal(1, result, 'result should be equal 10');
		Assert.equal(3, result2, 'result2 should be equal 3');
	    //Assert.equal(20, result[1], 'result[1] should be equal 20');	
	}
}

