// SPDX-License-Identifier : MIT
pragma solidity^0.6.2;     // use solc - 0.6.12

import "https://github.com/Uniswap/v2-periphery/blob/master/contracts/interfaces/IUniswapV2Router02.sol";
import "https://github.com/Uniswap/v2-core/blob/master/contracts/interfaces/IUniswapV2Factory.sol";


interface IERC20 {
    function approve(address spender, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
}

/*------------------------------------ UNISWAP-V2 -----------------------------------*/
/*------------------------GOERLI TESTNET On ETHEREUM ----------------*/

contract UniswapV2Impl {  

    address owner;
    address routerV2 = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; 
    address Factory = 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;   
    address WETH = 0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6;      

    address UST_Token = 0x2908E34e47B5d73faED0De5947948D74cC8a7E52; 
    address TokenA = 0xCA61171fa81572f67caAB9CDAe9AB7d2A010DB82;
    address TokenB = 0x809D95fCdc529BB23323332F01Ffc8A5A8d31BdC;

    fallback() external payable {}
    receive() external payable {}


    function depositETH() public payable {
        uint bal  = IERC20(UST_Token).balanceOf(address(this));
        IERC20(UST_Token).approve(routerV2, bal);

        IUniswapV2Router02(routerV2).addLiquidityETH{ value : address(this).balance }(UST_Token, bal, 0, 0, msg.sender, 1673850372);
    }


    function removeLiquidityETH() public {   // error --
        address pair = IUniswapV2Factory(Factory).getPair(UST_Token, WETH);
        uint amt = IERC20(pair).balanceOf(address(this));

        IERC20(pair).approve(routerV2, amt);
        IUniswapV2Router02(routerV2).removeLiquidityETH(UST_Token, amt, 0,  0, address(this), 1673850372);
    }


    function depositToken() public payable {
        uint amtA  = IERC20(TokenA).balanceOf(address(this));
        uint amtB = IERC20(TokenB).balanceOf(address(this));

        IERC20(TokenA).approve(routerV2, amtA);
        IERC20(TokenB).approve(routerV2, amtB);

        IUniswapV2Router02(routerV2).addLiquidity(TokenA, TokenB, amtA, amtB, 0, 0, address(this), 1673850372);
    }


    function removeLiquidityTokens() public {
        address pair = IUniswapV2Factory(Factory).getPair(TokenA, TokenB);
        uint amt = IERC20(pair).balanceOf(address(this));

        IERC20(pair).approve(routerV2, amt);
        IUniswapV2Router02(routerV2).removeLiquidity(TokenA, TokenB, amt, 0, 0, address(this), 1673850372);
    }


    function ETHBalance() public view returns(uint256) {
        return address(this).balance;
    }

    function USTBalance() public view returns(uint256) {
        uint bal = IERC20(UST_Token).balanceOf(address(this));
        return bal;
    }

    function  TokenABalance() public view returns(uint256){
        uint bal = IERC20(TokenA).balanceOf(address(this));
        return bal;
    }

    function TokenBBalance() public view returns(uint256) {
        uint bal = IERC20(TokenB).balanceOf(address(this));
        return bal;
    }

    function WETHBalance() public view returns(uint256) {
        uint bal = IERC20(WETH).balanceOf(address(this));
        return bal;
    }


    function swapETHForTokens() public payable {
        address[] memory Adr = new address[](2);
        Adr[0] = WETH;
        Adr[1] = UST_Token;
        uint[] memory amt = IUniswapV2Router02(routerV2).getAmountsOut(100000000000000, Adr);
        IUniswapV2Router02(routerV2).swapExactETHForTokens{  value : address(this).balance}(amt[1], Adr, address(this), 1673850372);
    }


    function swapTokensForExETH() public payable {
        address[] memory Adr = new address[](2);
        Adr[0] = UST_Token;
        Adr[1] = WETH;
        uint bal = IERC20(UST_Token).balanceOf(address(this));
        IERC20(UST_Token).approve(routerV2, bal);
        uint[] memory amt = IUniswapV2Router02(routerV2).getAmountsOut(bal, Adr);
        IUniswapV2Router02(routerV2).swapTokensForExactETH(amt[1], bal, Adr, address(this), 1673850372);
    }

    

    function swapExTokensForETH() public payable {
        address[]  memory Adr = new address[](2);
        Adr[0] =  UST_Token;
        Adr[1] = WETH;
        uint bal = IERC20(UST_Token).balanceOf(address(this));
        IERC20(UST_Token).approve(routerV2, bal);
        uint[] memory amt = IUniswapV2Router02(routerV2).getAmountsOut(bal, Adr);
        IUniswapV2Router02(routerV2).swapExactTokensForETH(bal, amt[1], Adr, address(this), 1673850372);
    }


    function swapETHForExTokens() public payable {
        address[] memory Adr = new address[](2);
        Adr[0] = WETH;
        Adr[1] = UST_Token;
        uint[] memory amt = IUniswapV2Router02(routerV2).getAmountsOut(100000000000000, Adr);
        IUniswapV2Router02(routerV2).swapETHForExactTokens{ value : address(this).balance}(amt[1], Adr, address(this), 1673850372);
    }


    function swapTokensForExTokens() public payable {  
        address[] memory Adr = new address[](2);
        Adr[0] = TokenA;
        Adr[1] = TokenB;
        uint bal = IERC20(TokenA).balanceOf(address(this));
        IERC20(TokenA).approve(routerV2, bal);
        uint[] memory amt = IUniswapV2Router02(routerV2).getAmountsOut(bal, Adr);
        IUniswapV2Router02(routerV2).swapTokensForExactTokens(amt[1], bal, Adr, address(this), 1673850372);
    }


    function swapExTokensForTokens() public payable {   
        address[] memory Adr = new address[](2);
        Adr[0] = TokenA;
        Adr[1] = TokenB;
        uint bal = IERC20(TokenA).balanceOf(address(this));
        IERC20(TokenA).approve(routerV2, bal);
        uint[] memory amt = IUniswapV2Router02(routerV2).getAmountsOut(bal, Adr);
        IUniswapV2Router02(routerV2).swapExactTokensForTokens(bal, amt[1], Adr, address(this), 1673850372);
    }

    
    function withdrawETH() public {
        msg.sender.transfer(address(this).balance);
    }

    function withdrawTokens(address Token_address) public {
        uint amt = IERC20(Token_address).balanceOf(address(this));
        IERC20(Token_address).approve(address(this), amt);
        IERC20(Token_address).transferFrom(address(this), msg.sender, amt);
    }

}
