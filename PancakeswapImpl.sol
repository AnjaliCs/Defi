// SPDX-License-Identifier : MIT
pragma solidity^0.8.0;

import "https://github.com/Uniswap/v2-core/blob/master/contracts/interfaces/IUniswapV2Factory.sol";
import "https://github.com/Uniswap/v2-periphery/blob/master/contracts/interfaces/IUniswapV2Router02.sol";

import "https://github.com/pancakeswap/pancake-swap-core/blob/master/contracts/interfaces/IPancakeFactory.sol";

interface IERC20 {
    function balanceOf(address account) external view returns(uint256);
    function approve(address spender, uint256 amount) external returns(bool);
    function transferFrom(address from, address to, uint256 amount) external returns(bool);
}

/*----------------------------UNISWAP-PANCAKESWAP-V2 ---------------------------------*/
/*-------------------------------- BSC TESTNET -----------------------------*/


contract PancakeSwapImpl {
    address Factory = 0x6725F303b657a9451d8BA641348b6761A6CC7a17;
    address Router = 0xD99D1c33F9fC3444f8101754aBC46c52416550D1;
    address WBNB = 0xae13d989daC2f0dEbFf460aC112a837C89BAa7cd; 
    
    // ERC20 Tokens deployed on BSC
    address BUX = 0x402Df1604F8c7EddB7a2a191237AdE1Fa18B4eE1;   
    address BPT = 0xA2bbf17a20FD1b0b75824167EdF71E1A2330fcbe;
    address MTK = 0xFd5c8DC9A3382674ddbFCf306Ea87679884d7b8A;  

    fallback() external payable{}
    receive() external payable{}


    function depositBNB() public {
        uint256 bal = IERC20(MTK).balanceOf(address(this));
        IERC20(MTK).approve(Router, bal);
        IUniswapV2Router02(Router).addLiquidityETH{ value : address(this).balance }(MTK, bal, 1, 1, msg.sender, 1674455785);
    }


    function removeEth() public {   // ERROR --
        address pair = IUniswapV2Factory(Factory).getPair(MTK, WBNB);
        uint256 amt = IERC20(pair).balanceOf(address(this));
        IERC20(pair).approve(Router, amt);
        IUniswapV2Router02(Router).removeLiquidityETH(MTK, amt, 0, 0, msg.sender, 1674455785);
    }


    function depositTokens() public {
        uint256 amtA = IERC20(BUX).balanceOf(address(this));
        uint256 amtB = IERC20(BPT).balanceOf(address(this));
        IERC20(BUX).approve(Router, amtA);
        IERC20(BPT).approve(Router, amtB);
        IUniswapV2Router02(Router).addLiquidity(BUX, BPT, amtA, amtB,  1, 1, msg.sender, 1674455785);
    }


    function removeTokens() public {  // ERROR --
        address pair = IUniswapV2Factory(Factory).getPair(BUX, BPT);
        uint256 amt = IERC20(pair).balanceOf(address(this));
        IERC20(pair).approve(Router, amt);
        IUniswapV2Router02(Router).removeLiquidity(BUX, BPT, amt, 0, 0, msg.sender, 1674455785);
    }


    function swapExBNBForTokens() public payable {
        address[] memory path = new address[](2);
        path[0] = WBNB;
        path[1] = MTK;
        uint256[] memory amt = IUniswapV2Router02(Router).getAmountsOut(100000000000000, path);
        IUniswapV2Router02(Router).swapExactETHForTokens{ value : address(this).balance }(amt[1], path, address(this), 1674455785);
    }


    function swapTokensForExBNB() public {
        address[] memory path = new address[](2);
        path[0] = MTK;
        path[1] = WBNB;
        uint256 bal = IERC20(MTK).balanceOf(address(this));
        IERC20(MTK).approve(Router, bal);
        uint256[] memory amt = IUniswapV2Router02(Router).getAmountsOut(bal, path);
        IUniswapV2Router02(Router).swapTokensForExactETH(amt[1], bal, path, address(this), 1674455785);
    }


    function swapEXTokensForBNB() public {
        address[] memory path = new address[](2);
        path[0] = MTK;
        path[1] = WBNB;
        uint256 bal  = IERC20(MTK).balanceOf(address(this));
        IERC20(MTK).approve(Router, bal);
        uint256[] memory amt = IUniswapV2Router02(Router).getAmountsOut(bal, path);
        IUniswapV2Router02(Router).swapExactTokensForETH(bal, amt[1], path, address(this), 1674455785);
    }


    function swapBNBForExTokens() public payable {
        address[] memory path = new address[](2);
        path[0] = WBNB;
        path[1] = MTK;
        uint256[] memory amt = IUniswapV2Router02(Router).getAmountsOut(100000000000000, path);
        IUniswapV2Router02(Router).swapETHForExactTokens{ value : address(this).balance }(amt[1], path, address(this), 1674455785);
    }


    function swapExTokensForTokens() public {
        address[] memory path = new address[](2);
        path[0] = BUX;
        path[1] = BPT;
        uint256 bal =  IERC20(BUX).balanceOf(address(this));
        IERC20(BUX).approve(Router, bal);
        uint256[] memory amt = IUniswapV2Router02(Router).getAmountsOut(bal, path);
        IUniswapV2Router02(Router).swapExactTokensForTokens(bal, amt[1], path, address(this), 1674455785);
    }


    function swapTokensForExTokens() public {
        address[] memory path = new address[](2);
        path[0] = BUX;
        path[1] = BPT;
        uint256 bal = IERC20(BUX).balanceOf(address(this));
        IERC20(BUX).approve(Router, bal);
        uint256[] memory amt = IUniswapV2Router02(Router).getAmountsOut(bal, path);
        IUniswapV2Router02(Router).swapTokensForExactTokens(amt[1], bal, path, address(this), 1674455785);
    }


    function checkBNB() public view returns(uint256) {
        return address(this).balance;
    }

    function checkMTK() public view returns(uint256) {
        uint256 bal = IERC20(MTK).balanceOf(address(this));
        return bal;
    }

    function checkBUX() public view returns(uint256) {
        uint256 bal = IERC20(BUX).balanceOf(address(this));
        return bal;
    }

    function checkBPT() public view returns(uint256) {
        uint256 bal = IERC20(BPT).balanceOf(address(this));
        return bal;
    }


    function withdrawBNB() public {
        uint amt = address(this).balance;
        payable(msg.sender).transfer(amt);
    }

    function withdrawToken(address Token_Adr) public {
        uint amt = IERC20(Token_Adr).balanceOf(address(this));
        IERC20(Token_Adr).approve(address(this), amt);
        IERC20(Token_Adr).transferFrom(address(this), msg.sender, amt);        
    }

}
