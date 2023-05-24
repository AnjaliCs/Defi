// SPDX-License-Identifier :  MIT
pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";
import "https://github.com/Uniswap/v2-core/blob/master/contracts/interfaces/IUniswapV2Factory.sol";
import "https://github.com/Uniswap/v2-core/blob/master/contracts/interfaces/IUniswapV2Pair.sol";

interface IUniswapV2Callee {
    function uniswapV2Call(
        address sender,
        uint256 amount0,
        uint256 amount1,
        bytes calldata data) external;
}

/*-------------------------------------------- ETHEREUM GOERLI TESTNET  -----------------------------------*/

contract flashSwap {
    address private constant WETH = 0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6;
    address private constant UniswapV2Factory = 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;


    function testFlashSwap(address _tokenBorrow, uint256 _amount) external {
        address pair = IUniswapV2Factory(UniswapV2Factory).getPair(_tokenBorrow, WETH);
        require(pair != address(0), "Pair contract address cannot  be zero");

        address token0 = IUniswapV2Pair(pair).token0();
        address token1 = IUniswapV2Pair(pair).token1();

        uint256 amount0Out = _tokenBorrow == token0 ? _amount : 0;
        uint256 amount1Out = _tokenBorrow == token1 ? _amount : 0;

        bytes memory data = abi.encode(_tokenBorrow, _amount);
        IUniswapV2Pair(pair).swap(amount0Out, amount1Out, address(this), data);
    }


    function UniswapV2Call(
        address sender,
        bytes calldata data
    ) external {
        address token0 = IUniswapV2Pair(msg.sender).token0();
        address token1 = IUniswapV2Pair(msg.sender).token1();

        address pair =  IUniswapV2Factory(UniswapV2Factory).getPair(token0, token1);
        require(msg.sender == pair, "Only called by Pair contract");
        require(sender == address(this), "Sender should be the current contract");

        (address tokenBorrow, uint256 amount) = abi.decode(data, (address, uint256));

        uint256 uniswapFee = ((amount*3)/997) + 1;
        uint256 amountToRepay = amount + uniswapFee;

        IERC20(tokenBorrow).transfer(pair, amountToRepay);
    }


    function Token_Balance(address _adr) public view returns (uint256) {
        uint256 amount = IERC20(_adr).balanceOf(address(this));
        return amount;
    }
}
