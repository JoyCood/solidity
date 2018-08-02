pragma solidity ^0.4.16;

contract owned {
    address public owner;

	constructor() public {
        owner = msg.sender;	
	}

	modifier onlyOwner {
	    require(msg.sender == owner);
		_;
	}

	function transferOwnership(address newOwner) onlyOwner public {
        owner = newOwner;	
	}
}

interface tokenRecipient {
    function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) external; 
}

contract TokenERC20 {
    string public name;
	string public symbol;
	uint8 public decimals = 18;

	uint256 public totalSupply;

	mapping (address => uint256) public balanceOf;
	mapping (address => mapping (address => uint256)) public allowance;

	event LogTransfer(address indexed _from, address indexed _to, uint256 _value);
	event LogApproval(address indexed _owner, address indexed _spender,  uint256 value);
	event LogBurn(address indexed _from, uint256 _value);

	constructor(
	    uint256 _initialSupply,
		string _tokenName,
		string _tokenSymbol
	) public {
        totalSupply = _initialSupply * 10 ** uint256(decimals);	
		balanceOf[msg.sender] = totalSupply;
		name = _tokenName;
		symbol = _tokenSymbol;
	}

	function _transfer(address _from, address _to, uint _value) internal {
        require(_to != 0x0);	
		require(balanceOf[_from] >= _value);
		require(balanceOf[_to] + _value > balanceOf[_to]);
		uint previousBalances = balanceOf[_from] + balanceOf[_to];
		balanceOf[_from] -= _value;
		balanceOf[_to] += _value;
		emit LogTransfer(_from, _to, _value);
		assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
	}

	function transfer(address _to, uint256 _value) public returns (bool) {
	    _transfer(msg.sender, _to, _value);
		return true;
	}

	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
	    require(_value <= allowance[_from][msg.sender]);
		allowance[_from][msg.sender] -= _value;
		_transfer(_from, _to, _value);
		return true;
	}

	function approve(address _spender, uint256 _value) public returns (bool) {
	    allowance[msg.sender][_spender] = _value;
		emit LogApproval(msg.sender, _spender, _value);
		return true;
	}

	function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool) {
	    tokenRecipient spender = tokenRecipient(_spender);
		if (approve(_spender, _value)) {
		    spender.receiveApproval(msg.sender, _value, this, _extraData);
			return true;
		}
	}

	function burn(uint256 _value) public returns (bool) {
	    require(balanceOf[msg.sender] >= _value);
		balanceOf[msg.sender] -= _value;
		totalSupply -= _value;
		emit LogBurn(msg.sender, _value);
		return true;
	}

	function burnFrom(address _from, uint256 _value) public returns (bool) {
	    require(balanceOf[_from] >= _value);
		require(_value <= allowance[_from][msg.sender]);
		balanceOf[_from] -= _value;
		allowance[_from][msg.sender] -= _value;
		totalSupply -= _value;
		emit LogBurn(_from, _value);
		return true;
	}
}

contract MyAdvancedToken is owned, TokenERC20 {
    uint256 public sellPrice;
	uint256 public buyPrice;

	mapping (address => bool) public frozenAccount;
	
	event LogFrozenFunds(address target, bool frozen);

	constructor(
	    uint256 _initialSupply,
		string _tokenName,
		string _tokenSymbol
	) TokenERC20(_initialSupply, _tokenName, _tokenSymbol) public {}

	function _transfer(address _from, address _to, uint _value) internal {
        require(_to != 0x0);	
		require(balanceOf[_from] >= _value);
		require(balanceOf[_to] + _value >= balanceOf[_to]);
		require(!frozenAccount[_from]);
		require(!frozenAccount[_to]);
		balanceOf[_from] -= _value;
		balanceOf[_to] += _value;
		emit LogTransfer(_from, _to, _value);
	}

	function mintToken(address _target, uint256 _mintedAmount) onlyOwner public {
        balanceOf[_target] += _mintedAmount;	
		totalSupply += _mintedAmount;
		emit LogTransfer(0, this, _mintedAmount);
		emit LogTransfer(this, _target, _mintedAmount); 
	}

	function freezeAccount(address _target, bool _freeze) onlyOwner public {
        frozenAccount[_target] = _freeze;	
		emit LogFrozenFunds(_target, _freeze);
	}

	function setPrices(uint256 _newSellPrice, uint256 _newBuyPrice) onlyOwner public {
	    sellPrice = _newSellPrice;
		buyPrice = _newBuyPrice;
	}

	function buy() payable public {
        uint amount = msg.value / buyPrice;	
		_transfer(this, msg.sender, amount);
	}

	function sell(uint256 amount) public {
	    address myAddress = this;
		require(myAddress.balance >= amount * sellPrice);
		_transfer(msg.sender, this, amount);
		msg.sender.transfer(amount * sellPrice);
	}
}
