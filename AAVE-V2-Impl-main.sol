// SPDX-License-Identofier : UNLICENSED
pragma solidity^0.6.0;

import "https://github.com/aave/protocol-v2/blob/master/contracts/misc/interfaces/IWETHGateway.sol";
import "https://github.com/aave/protocol-v2/blob/master/contracts/interfaces/ILendingPool.sol";

interface IPool {
    function deposit(address, uint, uint) external payable;
}

interface IPoolAddressesProvider {
    function getLendingPool() external view returns(address);
}

interface IERC20 {
    function approve(address spender, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
}

/*----------------------------------- ETHEREUM GOERLI TESTNET-----------------------------------*/

contract AaveImpl {
    IPoolAddressesProvider IP;
    address DAI_Tokens = 0x75Ab5AB1Eef154C0352Fc31D2428Cef80C7F8B33; 
    address LendingPoolAddressProvider = 0x5E52dEc931FFb32f609681B8438A51c675cc232d;  
    address WETHGateway = 0x3bd3a20Ac9Ff1dda1D99C0dFCE6D65C4960B3627; 
    address aWETH = 0x22404B0e2a7067068AcdaDd8f9D586F834cCe2c5;

    fallback() external payable{}
    receive() external payable{}

    event Address(address, address);
    event Adr(address);


    function checkBalance() public view returns(uint) {
        return address(this).balance;
    }

    function checkDAIbalance() public view returns(uint) {
        return IERC20(DAI_Tokens).balanceOf(address(this));
    }


    function addLiquidity() public returns(address) {
        address temp = IPoolAddressesProvider(LendingPoolAddressProvider).getLendingPool();
        emit Adr(temp);
        uint bal = IERC20(DAI_Tokens).balanceOf(address(this));
        IERC20(DAI_Tokens).approve(temp, bal);
        ILendingPool(temp).deposit(DAI_Tokens, bal, address(this), 0);
        return temp;
    }
   

    function withdrawLiquidity() public returns(address) {
        address temp = IPoolAddressesProvider(LendingPoolAddressProvider).getLendingPool();
        emit Adr(temp);
        ILendingPool(temp).withdraw(DAI_Tokens, type(uint).max, msg.sender);
        return temp;
    }


    function borrowAssets() public returns(address) {   // CHECK --
        address temp = IPoolAddressesProvider(LendingPoolAddressProvider).getLendingPool();
        emit Adr(temp);
        ILendingPool(temp).borrow(DAI_Tokens, type(uint).max, 1, 0, msg.sender);
        return temp;
    }
    
    
    function repayAssets() public returns(address) {   // CHECK --
        address temp = IPoolAddressesProvider(LendingPoolAddressProvider).getLendingPool();
        emit Adr(temp);
        ILendingPool(temp).repay(DAI_Tokens, uint(-1), 1, msg.sender);
        return temp;
    }


    function addLiquidityETH() public returns(address) {
        address temp = IPoolAddressesProvider(LendingPoolAddressProvider).getLendingPool();
        emit Adr(temp);
        IWETHGateway(WETHGateway).depositETH{ value : address(this).balance}(temp, msg.sender, 0);
        return temp;
    }


    function withdrawLiquiditytETH() public returns(bool) {   
        address temp = IPoolAddressesProvider(LendingPoolAddressProvider).getLendingPool();
        emit Adr(temp);
        IERC20(aWETH).approve(WETHGateway, type(uint).max);
        IWETHGateway(WETHGateway).withdrawETH(temp, type(uint).max, address(this));
        return true;
    }


    function borrowLiquidityETH() public returns(address) {  // CHECK --
        address temp = IPoolAddressesProvider(LendingPoolAddressProvider).getLendingPool();
        emit Adr(temp);
        IWETHGateway(WETHGateway).borrowETH(temp,  100000000000000, 1, 0);
        return temp;
    }
    

    function repayAssetForETH() public returns(address) {  // CHECK --
        address temp = IPoolAddressesProvider(LendingPoolAddressProvider).getLendingPool();
        emit Adr(temp);
        IWETHGateway(WETHGateway).repayETH(temp, 100000000000000, 1, msg.sender);
        return temp;
    }

}
