pragma solidity ^0.4.24;
//pragma experimental ABIEncoderV2; //打开实验性的功能特性

contract Hello {
	uint x = 10;
	uint y = x; //值的拷贝 (非引用，示例:t7() )

	uint[4] x_array = [1, 2, 3, 4];
	uint[4] y_array = x_array; //值的拷贝 (非引用，示例:t8() )
	uint[4] z_array; //定长数组没push及pop方法
	uint[]  k_array; //动长数组有push、pop方法

	mapping(uint256 => uint) private map;
    mapping(uint256 => uint[]) private map2;
	mapping(uint256 => Person) private map3;

	struct Person { //不能在这里预设struct类型的默认值
	    string name;
		string sex;
		uint8  age;
	}

	Person[] person_list;
    
	Person p;

	uint private remoteValue;

	//可以声明事件参数为结构体，实际不能发送结构体类型数据
	event Personx(Person xx);
	event T22_Logger(uint value);
	event Fallback_Logger(uint balance);
	event Sender_Logger(address sender);

	//构造函数，在布置合约的时候调用，只能调用一次
	//不支持重载
    constructor(uint8 _value) public {
	    x = _value;
		//this.t2();//不能在析构函数中使用this关键字，因为此时合约还没完成创建
	}

	//没啥好说的
	function t1(uint8 _value) public returns (uint){
		x = _value;
		return x;
	}

	/**
	 *  关键字view与constant的作用一样，只读取状态变量的值，而不改变其值
	 *  下面几种情况视为改变状态变量的值:
	 *    - 对状态变量进行写操作.
	 *    - 发送事件
	 *    - 使用selfdestruct
	 *    - 创建其它合约
	 *    - 调用call函数发送以太币 (Sending Ether via calls)
	 *    - 调用没有声明为view或pure的函数
	 *    - 使用底层的call函数 (Using low-level calls)
	 *    - 使用某些汇编指令 (Using inline assembly that contains certain opcodes)
	 */
	function t2() public view returns (uint) {
	    return x;
	}

	/**
	 * 我是来演示pure关键字的用法的
	 * pure关键字用来表示此函数既不读取状态变量也不修改状态变量
	 * 如下几种情况视为读取状态变量:
	 *   - 读取状态变量
	 *   - 读取this.balance或<address>.balance
	 *   - 读取区块中的block、tx、msg属性
	 *     (Accessing any of the members of block, tx, msg 
	 *	   (with the exception of msg.sig and msg.data).)
	 *	 - 调用没用声明为pure的函数
	 *	 - 使用某些汇编指令
	 */
	function t3(int _value) public pure returns (int) {
	    return _value+1;
	}

    /**
	 * 演示mapping的使用
	 * - mapping只能声明为全局变量, 不能在函数中声明一个mapping
	 * - 函数的参数不能为mapping
	 * - mapping的key可以任意类型，除了以下几种：
	 *     - mapping 
	 *     - 动态长度的数组 (dynamically sized array)
	 *     - 合约 (contract)
	 *     - 枚举 (enum)
	 *     - 结构体 (struct)
	 * - mpping的value可以为任意类型
	 */
	function t4() public returns (uint) {
		map[10] = 1;
        return map[10];
	}

	/**
	 * 函数返回动态长度数组
	 */
	function t5() public returns (uint[]) {
		map2[10].push(100); //push之后返回数组新的长度值
		map2[10].push(101);
		map2[10].push(102);
		return map2[10];
	} 

	/**
	 * 函数返回多个值
	 */
	function t6() public pure returns (int, string) {
	    //uint x = 100; //局部变量
	    return (1, 'second');
	}

	/**
	 * 函数重载
	 */
	function t6(int _value) public pure returns (int) {
	    return _value;
	}

	/**
	 * 函数重载
	 */
	function t6(int _value, string _value2) public pure returns (int, string) {
	    return (_value, _value2);
	}

	/**
	 * 函数重载
	 */
	function t6(string _value) public pure returns (string) {
	    return _value;
	}

	/**
	 * 整型值的拷贝示例
	 */
	function t7() public returns (uint) {
	    y = 11;
		return x;
	}

	/**
	 * 数组值的拷贝示例
	 * 返回指定N个数组元素
	 * 虽然在外函数外部声明了: uint[4] y_array = x_array
	 * 下面改变了y_array的值并不会影响x_array的值
	 */
	function t8() public returns (uint[4]) {
	    y_array[0] = 100;
		y_array[1] = 200;

		return x_array;
	}

	/**
	 * 引用全局数组示例
	 * - 全局数组元素是固定的情况下，
	 *   返回全局数组变量的时候必须指定与全局数组元素个数一致数组,
	 *	 如示例中的returns (uint[4]) 
	 *
	 * - 在数组变量名前加storage关键字编译时消除警告信息 (默认为storage)
	 * - 在函数中声明本地变量时，
	 *   只能对数组或结构体类型变量使用storage、memory关键字
	 */
	function t9() public returns (uint[4]) {
		//不允许对非数组、非结构体之外的变量使用memory或storage
		//uint storage _tmp = 10;
		//uint memory _tmp = 10;

	    uint[4] storage _value = x_array;
		_value[0] = 100;
		_value[3] = 300;

		return x_array;
	}

	/**
	 * 当在数组变量名前加memory关键字时，
	 * 只是对全局数组进行值的拷贝，而非引用
	 */
	function t10() public view returns (uint[4]) {
	    uint[4] memory _value = x_array;
		_value[0] = 200;
		return x_array;
	}

	/**
	 * 变长数组push演示
	 * - 如果返回值是变长数组，返回值不能为定长数组。如returns (uint[N])
	 */
	function t11() public returns (uint[]) {
	    //z_array.push(100); //z_array是定长数组，不支持push或pop方法
		//k_array[2] = 10;   //访问未初始化的变长数组会抛出运行错误
        //z_array = [uint(1), 2, 3, 4, 5]; //因为z_array是长度为4的定长数组，超出长度将报错

		z_array = [uint(1), 2, 3, 4]; //通过字面量初始化定长数组
		k_array = [uint(1), 2, 3, 4]; //可以通过字面量初始化变长数组

		k_array.length = 100; //设置变长数组长度为100个元素，第0~99个元素初值值为0
		k_array[10] = 100; //将下标为10的元素值设置为100
		
		k_array.push(1); //push值为1的元素到数组尾部 (在数组下标为100的位置)
		k_array.push(2); //push 2 (在下标为101的位置)
		k_array.push(3);
		k_array.push(4); //数组长度此时为104

		return k_array;
	}


	function t12() public pure returns (uint[]) {
	   // uint[] memory _value = [uint(1), 2, 3]; //不能通过字面量初始化数组
	   // uint[] storage _value = new uint[](10); //memory数组不能赋值给storage变量 

        uint[] memory _value = new uint[](10); //创建10个元素长度的数组，初始值为0	
		//_value.push(10); //memory 类型数组不支持push、pop方法
		_value[0] = 1;
		_value[3] = 4;
		return _value;
	}

	function t13() public returns (uint, uint, uint, uint) {
	    uint _value = 10;
		delete _value; //delete一个整数，只是将其值设置为0
		_value += 1;   //这个表达式的结果为1

		uint[] memory _value2 = new uint[](10);
		for(uint i=0; i<_value2.length; i++) {
		    _value2[i] = i;
		}
	    delete _value2; //对于动长数组，delete将其数组长度置为0	
		//_value2[0] = 1; //访问长度为0的数组会报错
	
	    //uint[] storage k_local = k_array;	
		//delete k_local; //删除k_local是非法的，会报错

		delete k_array; //全局动长数组, delete将其数组长度置为0
		//k_array[0] = 1; //数组长度为0，越界访问会报错

        delete z_array; //对于全局定长数组，delete将其元素置为默认值，数组长度不变
		z_array[0] = 1;

		return (_value, _value2.length, k_array.length, z_array.length);
	}

	/**
	 * 函数传参方式示例
	 *
	 * memory变量传给memory类型的参数   -> 引用传参
	 * storage变量传给storage类型的参数 -> 引用传参
	 * storage变量传给memory类型的参数  -> 值拷贝传递
	 *
	 * memory变量不能传给storage类型的参数 -> 报错
	 * 形参为storage的变量，权限只能为internal或private
	 */
	function t14() public returns (uint[], uint[]) {
	    uint[] memory _value = new uint[](1);
		_value[0] = 1;
		t14_1(_value); //_value[0] == 2 memory->memory 引用传参

		k_array.push(1);
		t14_2(k_array); //k_array[0] == 222 storage->storage 引用传参
		t14_3(k_array); //k_array[0] == 222 storage->memory  拷贝传参

		return (_value, k_array);
	}

	function t14_1(uint[] memory _value) public pure {
	    _value[0] += 1;
	} 

	function t14_2(uint[] storage _value) internal {
        _value[0] = 222;	
	}

	//参数声明为memory类型，实参为storage，结果为值传递
	function t14_3(uint[] memory _value) public pure {
        _value[0] = 111;	
	}

	function t15() public view returns (uint) {
		uint _x; 
		_x = this.t15_1();
		_x = this.t15_2();
		//_x = t15_1(); 调用external方法必须加this关键字
		//_x = this.t15_3(); 不能用this关键字调用internal方法
		//_x = this.t15_4(); 不能用this关键字调用private方法
		return _x;
	} 

	function t15_1() external pure returns (uint) {
	    return 99;
	}

	function t15_2() public pure returns (uint) {
	    return 100;
	}

	function t15_3() internal pure returns (uint) {
        return 101;	
	}

	function t15_4() private pure returns (uint) {
	    return 102;
	}

	/**
	 * 结构体赋值示例
	 */
	function t16() public returns (uint, uint, uint) {
		/*错误示范
		 Person storage person2 = Person({name:'jack', sex:'famale', age:18});
		 Person storage person3 = Person;
	    */

		Person memory person = t16_1({_name:'joy', _sex:'male', _age:10});
		t16_2(person); //memory->memory 引用传参: person.age == 100
		map3[1] = person; //拷贝赋值给变量map3[1]
		map3[1].age = 200; //因为是拷贝赋值, person.age == 100;

		map3[2] = map3[1]; //拷贝赋值
		map3[2].age = 210; //因为是拷贝赋值，所以: map3[1].age == 200

		p = map3[1]; //拷贝赋值
		p.age = 88; //不会影响map3[1].age的值
		t16_2(p); //storage->memory 拷贝传参
		t16_3(p); //storage->storage 引用传参 p.age == 11;

		Person storage person2 = map3[1]; //引用, person2指向map3[1]的元素
		person2.age = 30; //修改了map3[1]对象的值,由200变为30
		
		return (p.age, map3[1].age, map3[2].age);
	}
    
	//只有internal、private的方法能返回结构体类型
	function t16_1(string _name, string _sex, uint8 _age) 
	    internal 
	    pure 
	    returns (Person) 
	{
	    return Person({name:_name, sex:_sex, age:_age});
	}

	//结构体类型参数只能在internal、private方法下传递
	function t16_2(Person memory _person) internal {
        p = _person; //值拷贝
        _person.age = 100;	//不会影响p变量的值
	} 

	function t16_3(Person storage _person) internal {
	    _person.age = 11;
	}

	/**
	 * 给函数传递函数示例
	 */
	function t17() public pure returns (uint) {
	    return t17_1(1, t17_2);
	}

	function t17_1(
	    uint _value,
		function (uint) internal pure returns (uint) f //函数类型的参数
	) 
	    internal
		pure
		returns (uint)
	{
        return f(_value);	
	}

	function t17_2(uint _value) internal pure returns (uint) {
	    return _value += 1;
	}

    /**
	 * 二维数组示例
	 */
	function t18() public pure returns (uint) {
		//声明一个长度为10，其值为5个元素的数组的二维数组
	    uint[5][] memory _value = new uint[5][](10);
		t18_1(_value[0]);
		t18_2(_value);

		//return _value.length; //10
		//return _value[7].length; //5
		return _value[1][0];
	}

	function t18_1(uint[5] _value) public pure {
        _value[0] = 1; 	
		_value[1] = 2;
		_value[4] = 5;
	}  
    
	//支持合约内调用，返回嵌套数组
	function t18_2(uint[5][] _value) public pure returns (uint[5][]) {
        _value[1][0] = 100;
	    _value[1][1] = 101;	
		return _value;
	}

	//结构体类型数组示例
	function t19() public returns (uint8) {
	    Person[] memory _p = new Person[](10);

		for(uint i=0; i<_p.length; i++) {
	        _p[i] = Person({name:'foo', sex:'male', age:uint8(i)});	
			person_list.push(_p[i]);
		}

		return _p[9].age;
	}

	//返回值为函数示例
	function t20() public pure returns (uint) {
		//声明一个函数类型的变量 _f
	    function() internal pure returns(uint) _f = t20_1();
		return _f();
	}

	//返回一个函数类型的值
	function t20_1() internal pure returns (
		function() internal pure returns (uint)
	) {
	    return t20_2; 
	}

	function t20_2() internal pure returns (uint) {
	    return 10;
	}

    function t21(uint _value) external {
	    remoteValue = _value; 
	}

	function t22() public returns (uint) {
		emit T22_Logger(remoteValue);
	    return remoteValue;
	}

	function t23() public returns (address) {
		emit Sender_Logger(msg.sender);
	    return msg.sender;
	}

	function t24() public view returns (uint) {
	    return address(this).balance;
	}

	function t25() public pure returns (uint, uint) {
        bytes1 _value = 255;	
		bytes3 _value2 = 16777215; 
		return (_value.length, uint(_value2[0]));
	}

	/**
	 * - assert()应该用于检测合约内部潜在的致命错误
	 * - 发生assert类型错误的时候会消耗完所有剩余的gas，不会返回给调用者
	 *
	 * 如下情形会发生assert类型的错误
	 * 1. 数组越界(比如x[i], i>x.length或i<0) 
	 * 2. 越界访问定长字节类型bytesN
	 * 3. 求余数或商值时，除数为0 (比如5 / 0 或者 23 % 0)
	 * 4. 按负数位移
	 * 5. 将一个过大的值或负数转换成枚举类型
	 * 6. 调用一个未初始化的internal函数
	 * 7. assert()参数值为false
	 */
    function t26() public pure {
        assert(false);	
	}

	/**
	 * 匿名函数
	 * - 当调用合约中不存在的函数时，会触发此匿名函数
	 *   如用send()、transfer()给此合约转帐，会触发此函数
	 * - 如果想让此匿名函数具有接收代币的功能，必须加payable关键字
	 * - 一个合约只允许存在一个匿名函数
	 * - 匿名函数不允许带任何参数
	 * - 匿名函数不允许有返回值
	 * - 可见性必须为external？官方文档描述得有问题,实验证明public也可以
	 * - 匿名函数虽然不允许声明带参数，但可以通过msg.data属性
	 *   来获取传递过来的参数值
	 * - 只要给足gas，匿名函数跟其它普通函数一样可以做复杂的运算
	 */
	function () public payable {
        emit Fallback_Logger(address(this).balance);	
	}

    // 不支持在方法中动态创建mapping
    function e1() public pure {
	    //mapping(uint => uint) _x;
	    //_x[1] = 255;    
	}	
}
