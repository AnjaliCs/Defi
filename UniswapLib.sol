// SPDX-License-Identifier:  UNLICENSED

pragma solidity >= 0.6.0;

import 'https://github.com/SURF-Finance/contracts/blob/master/libraries/IUniswapV2Router02.sol';

interface IERC20 {
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
    function balanceOf(address adr) external view returns(uint);
}

library Lib {

    function balanceOfToken(address token_Adr) internal view returns(uint) {
        uint bal = IERC20(token_Adr).balanceOf(address(this));
        return bal;
    }
}


contract uniswapImpl {

    address public WETH_Address = 0xd0A1E359811322d97991E03f863a0C30C2cF029C;   // WETH
    address public ROUTER_Address = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // Uniswap Router
    address public tokenA = 0x8DF35A8B7be668eAb63158D222eBB308133c81b8;  // LTP Tokens
    address public tokenB = 0x44ad20C2b7752a90F7cBbdeaaacaa5154202069b;  // LYC Tokens
    address public token_Address = 0xb71C37585eef62D0e68AAd9A54A1D5355449A848;  //CAPs Token 


    function depositETH() public payable {
        IERC20(token_Address).approve(ROUTER_Address, Lib.balanceOfToken(token_Address));
        IUniswapV2Router02(ROUTER_Address).
        addLiquidityETH{ value: address(this).balance }(token_Address, Lib.balanceOfToken(token_Address), 0, 0, msg.sender, 1657860412);
    }


    function SwapETH() public payable {
        address[] memory Adr = new address[](2);
        Adr[0] = WETH_Address;
        Adr[1] = token_Address;
        uint[] memory amounts = IUniswapV2Router02(ROUTER_Address).getAmountsOut(100000000000000, Adr);
        IUniswapV2Router02(ROUTER_Address).
        swapExactETHForTokens{ value: address(this).balance }(amounts[1], Adr, msg.sender, 1657860412);
    }


    function getBalance() public view returns(uint) {
        return address(this).balance;
    }


    function depositTokens() public payable {
        IERC20(tokenA).approve(ROUTER_Address, Lib.balanceOfToken(tokenA));
        IERC20(tokenB).approve(ROUTER_Address, Lib.balanceOfToken(tokenB));
        IUniswapV2Router02(ROUTER_Address).
        addLiquidity(tokenA, tokenB, Lib.balanceOfToken(tokenA), Lib.balanceOfToken(tokenB), 0, 0, msg.sender, 1657860412);
    }


    function SwapTokens() public payable {
        address[] memory Adr = new address[](2);
        Adr[0] = token_Address;
        Adr[1] = WETH_Address;
        uint[] memory amt = IUniswapV2Router02(ROUTER_Address).getAmountsOut(Lib.balanceOfToken(token_Address), Adr);
        IERC20(token_Address).approve(ROUTER_Address, Lib.balanceOfToken(token_Address));
        IUniswapV2Router02(ROUTER_Address).swapTokensForExactETH(amt[1], Lib.balanceOfToken(token_Address), Adr, msg.sender, 1657860412);
    }


    function SwapTokensForToken() public payable {
        address[] memory Adr = new address[](2);
        Adr[0] = tokenA;
        Adr[1] = tokenB;
        uint[] memory amt = IUniswapV2Router02(ROUTER_Address).getAmountsOut(Lib.balanceOfToken(tokenA), Adr);
        IERC20(tokenA).approve(ROUTER_Address, Lib.balanceOfToken(tokenA));
        IUniswapV2Router02(ROUTER_Address).swapTokensForExactTokens(amt[1], Lib.balanceOfToken(tokenA), Adr, msg.sender, 1657860412);
    }


    fallback() external payable {}
    receive() external payable {}
   

    function checkTokenBalance() public view returns(uint) {
        uint amt = IERC20(token_Address).balanceOf(address(this));
        return amt;
    }

    function checkTokenBalanceOfA() public view returns(uint) {
        uint amt = IERC20(tokenA).balanceOf(address(this));
        return amt;
    }

    function checkTokenBalanceOfB() public view returns(uint) {
        uint amt = IERC20(tokenB).balanceOf(address(this));
        return amt;
    }
}
