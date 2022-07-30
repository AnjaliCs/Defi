// SPDX-License-Identifier: UNLICENSED

pragma solidity >= 0.5.0;

import 'https://github.com/aave/protocol-v2/blob/master/contracts/misc/interfaces/IWETHGateway.sol';
import 'https://github.com/aave/aave-js/blob/master/contracts/ILendingPool.sol';

interface IPoolAddressesProvider {
    function getLendingPool() external view returns(address);
}


interface IPool {
    function deposit(address,uint,uint) external payable;
}

interface IERC20 {
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
    function balanceOf(address adr) external view returns(uint);
}


contract aaveImpl {
    IPoolAddressesProvider public IP;
    //IWETH public IP_;

    address public tokenAdr = 0xFf795577d9AC8bD7D90Ee22b6C1703490b6512FD;   // DAI Tokens   -- on Kovan Testnet


    fallback() external payable {}
    receive() external payable {}


    event Address(address,address);
    event Adr(address);

    function getBalance() public view returns(uint) {
        return address(this).balance;
    }

   
    function addLiquidity() public returns(address) {   // For ERC20 Tokens
        address temp_ = IPoolAddressesProvider(0x88757f2f99175387aB4C6a4b3067c77A695b0349).getLendingPool();
        emit Adr(temp_);
        uint bal = IERC20(tokenAdr).balanceOf(address(this));
        IERC20(tokenAdr).approve(temp_, bal);
        ILendingPool(temp_).deposit(tokenAdr, bal, address(this), 0);

        return temp_;
    }


    function WithdrawLiquidity() public {               // For ERC20 Tokens
        address temp_ = IPoolAddressesProvider(0x88757f2f99175387aB4C6a4b3067c77A695b0349).getLendingPool();
        emit Adr(temp_);
        ILendingPool(temp_).withdraw(tokenAdr, type(uint).max, address(this));
    }

    

    function checkTokenBalance() public view returns(uint) {
        uint amt = IERC20(tokenAdr).balanceOf(address(this));
        return amt;
    }


    
    function deposit() public  returns(address) {     // For ETH
        address temp_ = IPoolAddressesProvider(0x88757f2f99175387aB4C6a4b3067c77A695b0349).getLendingPool();
        emit Adr(temp_);
        IWETHGateway(0xA61ca04DF33B72b235a8A28CfB535bb7A5271B70).depositETH{value:address(this).balance}(temp_, address(this), 0);

        return temp_;
    }



    function withdraw() public returns(bool) {        // For ETH
        address temp_ = IPoolAddressesProvider(0x88757f2f99175387aB4C6a4b3067c77A695b0349).getLendingPool();
        emit Adr(temp_);
        IERC20(0x87b1f4cf9BD63f7BBD3eE1aD04E8F52540349347).approve(0xA61ca04DF33B72b235a8A28CfB535bb7A5271B70, type(uint).max);
        IWETHGateway(0xA61ca04DF33B72b235a8A28CfB535bb7A5271B70).withdrawETH(temp_, type(uint).max, msg.sender);

        return true;
    }

} 
