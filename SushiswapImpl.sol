// SPDX-License-Identifier:  UNLICENSED

pragma solidity >= 0.6.0;

import "https://github.com/SURF-Finance/contracts/blob/master/libraries/IUniswapV2Router02.sol";

interface IERC20 {
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
    function balanceOf(address adr) external view returns(uint);
}

contract SushiswapImpl {

    address public LTP_Token = 0x8DF35A8B7be668eAb63158D222eBB308133c81b8; 
    address public LYC_Token = 0x44ad20C2b7752a90F7cBbdeaaacaa5154202069b;
    address public CAPS_Token = 0xb71C37585eef62D0e68AAd9A54A1D5355449A848;
    address public ROUTER = 0x1b02dA8Cb0d097eB8D57A175b88c7D8b47997506;    // on Kovan Testnet
    address public WETH = 0xd0A1E359811322d97991E03f863a0C30C2cF029C;


    function depositETH() public payable {
        uint bal = IERC20(CAPS_Token).balanceOf(address(this));
        IERC20(CAPS_Token).approve(ROUTER, bal);
        IUniswapV2Router02(ROUTER).
        addLiquidityETH{ value: address(this).balance }(CAPS_Token, bal, 0, 0, msg.sender, block.timestamp + 86400);
    }

    function SwapETH() public payable {
        address[] memory Adr = new address[](2);
        Adr[0] = WETH;
        Adr[1] = CAPS_Token;
        uint[] memory amounts = IUniswapV2Router02(ROUTER).getAmountsOut(100000000000000, Adr);
        IUniswapV2Router02(ROUTER).
        swapExactETHForTokens{ value: address(this).balance }(amounts[1], Adr, msg.sender, block.timestamp + 86400);
    }


    function depositTokens() public payable {
        uint balA = IERC20(LTP_Token).balanceOf(address(this));
        uint balB = IERC20(LYC_Token).balanceOf(address(this));
        IERC20(LTP_Token).approve(ROUTER, balA);
        IERC20(LYC_Token).approve(ROUTER, balB);
        IUniswapV2Router02(ROUTER).addLiquidity(LTP_Token, LYC_Token, balA, balB, 0, 0, msg.sender, block.timestamp + 86400);
    }
    
    
    function SwapTokensForToken() public payable {
        address[] memory Adr = new address[](2);
        Adr[0] = LTP_Token;
        Adr[1] = LYC_Token;
        uint bal = IERC20(LTP_Token).balanceOf(address(this));
        uint[] memory amt = IUniswapV2Router02(ROUTER).getAmountsOut(bal, Adr);
        IERC20(LTP_Token).approve(ROUTER, bal);
        IUniswapV2Router02(ROUTER).swapTokensForExactTokens(amt[1], bal, Adr, msg.sender, block.timestamp + 86400);
    }

    fallback() external payable {}
    receive() external payable {}

    function checkETH() public view returns(uint) {
        return address(this).balance;
    }

    function checkCAPS() public view returns(uint) {
        uint amt = IERC20(CAPS_Token).balanceOf(address(this));
        return amt;
    }

    function checkLTP() public view returns(uint) {
        uint amt = IERC20(LTP_Token).balanceOf(address(this));
        return amt;
    }

    function checkLYC() public view returns(uint) {
        uint amt = IERC20(LYC_Token).balanceOf(address(this));
        return amt;
    }

}
