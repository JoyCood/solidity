pragma solidity ^0.4.24;

import "./SafeERC20.sol";

contract TokenTimelock {
    using SafeERC20 for ERC20Basic; //创建一种数据类型并将SafeERC20中的属性方法添加到此数据类型中

	ERC20Basic public token;

	address public beneficiary; //受益人

	uint256 public releaseTime; //解锁时间

	constructor(
	    ERC20Basic _token,
		address _beneficiary,
		uint256 _releaseTime
	)
	    public
	{
	    require(_releaseTime > block.timestamp);
        token = _token;
		beneficiary = _beneficiary;
		releaseTime = _releaseTime;
	}

	function release() public {
	    require(block.timestamp >= releaseTime);

		uint256 amount = token.balanceOf(address(this));
		require(amount > 0);

		token.safeTransfer(beneficiary, amount);
	}
}
