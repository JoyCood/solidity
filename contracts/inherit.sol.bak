pragma solidity 0.4.24;

interface Regulator {
	//接口方法只能声明为external权限
    function checkValue(uint) external returns (bool);
	function loan() external view returns (bool);
}

contract Bank is Regulator {
    uint private value;

	constructor(uint amount) public {
	    value = amount;
	}

	function deposit(uint amount) public {
	    value += amount;
	}

	function withdraw(uint amount) public {
	    if (checkValue(amount)) {
		    value -= amount;
		}
	}

	function balance() public view returns (uint) {
	    return value;
	}

	function checkValue(uint amount) public view returns (bool) {
	    return value >= amount;
	}

	//实现接口时，方法必须为public、external权限,不能为internal、private权限
	function loan() public view returns (bool) {
	    return value > 0;
	}
}

contract MyFirstContract is Bank(10) {
    string private name;
	uint private age;
	uint[] private x;
	struct Person {
	    string name;
		uint age;
	}
	mapping(uint => string) employ;

	function setName(string _name) public {
	    name = _name;
	}

	function getName() public view returns (string) {
        return name;	
	}

	function setAge(uint _age) public {
	    age = _age;
	}

	function getAge() public view returns (uint) {
	    return age;
	}
    
	//支持方法重载
	function getAge(string) public view returns (uint) {
	    return age;
	}

	//支持省略无用的参数名,只声明参数类型，但参数一样会入栈
	function getAge(uint) public view returns (uint) {
	    return age;
	}




}
