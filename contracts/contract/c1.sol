pragma solidity ^0.4.24;

/**
 * library
 * - 不允许定义payable函数
 * - 不允许定义fallback函数
 * - 不能接收代币
 * - 
 */

/**
 * 接口
 * - 不能继承合约或接口
 * - 不能定义析构函数
 * - 不能定义状态变量
 * - 不能定义结构体
 * - 不能定义枚举类型
 * - 接口中的函数定义为external
 */
interface Token {
    function transfer(address recipient, uint amount) external;
}

/**
 * 抽象合约
 * - 定义：合约内有未实现的方法(即没有函数体的函数)
 * - 抽象合约无法编译
 * - 合约中只要有一个函数没实现就当作是抽象合约
 * - 抽象合约可以包含已实现的函数
 * - 抽象合约可以被继承
 * - 如果一个合约继承了抽象合约而并没有实现所有抽象函数，
 *   则派生出的合约也属于抽象合约
 */
contract ContractName {
    function funName() public returns (bytes32); 
	function funName2() external returns (bytes32);
	function funName3() public pure returns (string) {
	    return "hello world";
	}
}


/**
 * 声明要调用的外部合约函数
 * - 函数体为空
 * - 函数可见性可以为public、external。
 *   可以不与外部合约函数的可见性一致
 * - 在本合约中声明外部合约的函数只是为了生成ABI
 *   通过ABI调用外部合约是比较合适的调用方式，当然
 *   如果不想通过ABI也是可以调用外部合约的，比如通过call的方式
 */
contract Basic{
    function t21(uint) external pure {}
	function t22() public pure returns (uint) {} 
	function t23() public pure returns (address) {}
}

contract Transaction {
	Basic private basic;

    event SenderLogger(address sender);
	event ValueLogger(uint value);
	event BalanceLogger(uint balance);
	event BasicValueLogger(uint helloValue);
	event BasicSenderLogger(address sender);

	address private owner;

	modifier isOwner {
	    require(owner == msg.sender);
		_;
	}

	modifier validValue {
	    assert(msg.value >= 1 ether);
		_;
	}

	constructor(address BasicAddress) public {
	    owner = msg.sender;
		basic = Basic(BasicAddress);
        //Token token = Token(msg.sender);
		//token.transfer(msg.sender, 100000000);
	}

	/**
	 * 调用外部合约的函数并传递参数过去
	 * - 此种调用方式遵循了ABI规范，是比较正规安全的调用方式
	 * - 给普通函数加上payable关键字表明此函数具有接收代币的功能
	 */
	function setValueToBasicContract(uint _value) external payable {
		basic.t21(_value);
		emit BalanceLogger(address(this).balance);
	}

	/**
	 * 调用外部合约的函数获取返回值
	 *
	 * - 通过Web3的call方法调用此函数，不会调用外部合约，也不会触发事件
	 *   只是从本地读取数据并返回
	 * - Web3的call方法不能改变数据，亦不会消耗gas, 不会对网络广播
	 */
	function getValueFromBasicContract() public returns (uint) {
	    uint value = basic.t22();
		emit BasicValueLogger(value);
		return value;
	}

	/**
	 * 测试调用外部合约返回的msg.sender是合约地址还是用户地址
	 */
	function getSenderFromBasicContract() public returns (address) {
        address sender = basic.t23(); //实验证明，返回的是本合约地址	
		emit BasicSenderLogger(sender);
		return sender;
	}

	/**
	 * 不通过ABI规范的方式调用外部合约
	 * - 无法取得被调用合约的返回值(除非用汇编指令)
	 */
	function getValueFromBasicContractWithoutABI() public returns (uint) {
		//这行演示调用外部合约中一个不存在的函数也会返回成功
        //if(address(basic).call(bytes4(keccak256("t203()"))))
		//    emit SenderLogger(msg.sender);

		//call()、send()、delegatecall()、callcode()
		//函数在失败时不会抛出异常，而是会返回false
		if(!address(basic).call(bytes4(keccak256("t23"))))
			revert();

		return 1;
	}

	/**
	 * 给其它合约转帐
	 *
	 * 参考资料:
     *   https://ethereum.stackexchange.com/questions/38387/contract-address-transfer-method-gas-cost
	 */
	function sendEtherToBasicContract() public {
        //如果异常会回滚，会导致当前合约抛出异常并停止往下执行. 不能设置gas(默认2300)	
        address(basic).transfer(100000000); 
        
		//如果失败会返回false，不回滚, 不会导致本合约异常终止.不能设置gas（默认2300）
		require(address(basic).send(200000000)); 

		//这种方式具有被调用合约反调用的风险。可以设置gas
		if(!address(basic).call.value(300000000).gas(6000)())
		   revert();	

		emit BalanceLogger(address(this).balance);
	}
    
	/**
	 * 匿名函数
	 *
	 * - 当调用一个不存在的函数时会触发此匿名函数
	 * - 如果想让此函数具有接收ether的功能，必须加payable关键字
	 * - 一个合约只允许声明一个匿名函数
	 * - 匿名函数不能有任何参数
	 * - 匿名函数不能返回任何值
     * - 只要gas足够多，匿名函数也可以做复杂的运算
	 * - 可见性必须为external？官方文档描述得有问题,实验证明public也可以
	 * - 虽然匿名函数不允许有参数，但还是可以通过msg.data来获取调用时
	 *   传递过来的参数值
	 */
	function () external payable isOwner validValue {
        //emit SenderLogger(msg.sender); //发送者地址	
		//emit ValueLogger(msg.value);   //数字货币数量 (单位: wei)
		emit BalanceLogger(address(this).balance); //当前合约帐户余额(单位: wei)
	}
}
