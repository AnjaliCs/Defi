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

    address public tokenAdr = 0x001B3B4d0F3714Ca98ba10F6042DaEbF0B1B7b6F;   // DAI Tokens -- Mumbai Testnet


    fallback() external payable {}
    receive() external payable {}


    event Address(address,address);
    event Adr(address);

    function getBalance() public view returns(uint) {
        return address(this).balance;
    }


    function addLiquidity() public returns(address) {        // For ERC20 Tokens
        address temp_ = IPoolAddressesProvider(0x178113104fEcbcD7fF8669a0150721e231F0FD4B).getLendingPool();
        emit Adr(temp_);
        uint bal = IERC20(tokenAdr).balanceOf(address(this));
        IERC20(tokenAdr).approve(temp_, bal);
        ILendingPool(temp_).deposit(tokenAdr, bal, address(this), 0);

        return temp_;
    }


    function WithdrawLiquidity() public {                     // For ERC20 Tokens
        address temp_ = IPoolAddressesProvider(0x178113104fEcbcD7fF8669a0150721e231F0FD4B).getLendingPool();
        emit Adr(temp_);
        ILendingPool(temp_).withdraw(tokenAdr, type(uint).max, address(this));
    }

    


    function checkTokenBalance() public view returns(uint) {
        uint amt = IERC20(tokenAdr).balanceOf(address(this));
        return amt;
    }


    
    function deposit() public  returns(address) {     // For ETH
        address temp_ = IPoolAddressesProvider(0x178113104fEcbcD7fF8669a0150721e231F0FD4B).getLendingPool();
        emit Adr(temp_);
        IWETHGateway(0xee9eE614Ad26963bEc1Bec0D2c92879ae1F209fA).depositETH{value:address(this).balance}(temp_, address(this), 0);

        return temp_;
    }



    function withdraw() public returns(bool) {        // For ETH
        address temp_ = IPoolAddressesProvider(0x178113104fEcbcD7fF8669a0150721e231F0FD4B).getLendingPool();
        emit Adr(temp_);
        IERC20(0xF45444171435d0aCB08a8af493837eF18e86EE27).approve(0xee9eE614Ad26963bEc1Bec0D2c92879ae1F209fA, type(uint).max);
        IWETHGateway(0xee9eE614Ad26963bEc1Bec0D2c92879ae1F209fA).withdrawETH(temp_, type(uint).max, msg.sender);

        return true;
    }

} 
