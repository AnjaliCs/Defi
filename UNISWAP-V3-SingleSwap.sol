// SPDX-License-Identifier : MIT
pragma solidity^0.8.0;

import "https://github.com/Uniswap/v3-periphery/blob/main/contracts/interfaces/ISwapRouter.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";

/*-------------------------------- AVALAUNCHE FUJI TESTNET -------------------------------------------*/

contract singleSwap {
    address public Router = 0xE592427A0AEce92De3Edee1F18E0157C05861564;
    ISwapRouter public immutable swapRouter = ISwapRouter(Router);

    address public LINK = 0x0b9d5D9136855f6FEc3c0993feE6E9CE8a297846;
    address public WAVAX = 0xd00ae08403B9bbb9124bB305C09058E32C39A48c;

    IERC20 Link = IERC20(LINK);
    uint24 PoolFee = 3000;

    receive() external payable {}

    function LINKBalance() public view returns(uint256) {
        uint256 bal = IERC20(LINK).balanceOf(address(this));
        return bal;
    }

    function WAVAXBalance() public view returns(uint256) {
        uint256 bal = IERC20(WAVAX).balanceOf(address(this));
        return bal;
    }

    function withdrawLINK() public {
        uint256 amount = IERC20(LINK).balanceOf(address(this));
        payable(msg.sender).transfer(amount);
    }
    

    function swapExactInputSingle(uint256 amountIn) external returns(uint256 amountOut) {
        Link.approve(address(swapRouter), amountIn);

        ISwapRouter.ExactInputSingleParams memory params = ISwapRouter.ExactInputSingleParams({
            tokenIn : LINK,
            tokenOut : WAVAX,
            fee : PoolFee,
            recipient : address(this),
            deadline : block.timestamp,
            amountIn : amountIn,
            amountOutMinimum : 0,
            sqrtPriceLimitX96 : 0
        });

        amountOut = swapRouter.exactInputSingle(params);
    }

    function swapExactOutputSingle(uint256 amountOut, uint256 amountInMaximum) external returns(uint256 amountIn) {
        Link.approve(address(swapRouter), amountInMaximum);

        ISwapRouter.ExactOutputSingleParams memory params = ISwapRouter.ExactOutputSingleParams({
            tokenIn : LINK,
            tokenOut : WAVAX,
            fee : PoolFee,
            recipient : address(this),
            deadline : block.timestamp,
            amountOut : amountOut,
            amountInMaximum : amountInMaximum,
            sqrtPriceLimitX96  : 0
        });

        amountIn = swapRouter.exactOutputSingle(params);

        if(amountIn < amountInMaximum) {
            Link.approve(address(swapRouter), 0);
            Link.transfer(address(this), amountInMaximum - amountIn);
        }
    }
}
