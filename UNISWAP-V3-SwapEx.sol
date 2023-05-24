// SPDX-License-Identifier : MIT
pragma solidity^0.8.10;

import "https://github.com/Uniswap/solidity-lib/blob/master/contracts/libraries/TransferHelper.sol";
import "https://github.com/Uniswap/v3-periphery/blob/main/contracts/interfaces/ISwapRouter.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";

contract swapV3 {
    ISwapRouter public immutable swapRouter;
    uint24 public PoolFee = 3000;

    address public LINK = 0x326C977E6efc84E512bB9C30f76E30c160eD06FB;
    address public DAI = 0x75Ab5AB1Eef154C0352Fc31D2428Cef80C7F8B33;

    constructor(ISwapRouter _swapRouter) {
        swapRouter = _swapRouter;
    }

    function swapTokens(address tokenIn, address tokenOut, uint256 amountIn) public returns(uint256 amountOut) {

        TransferHelper.safeTransferFrom(tokenIn, msg.sender, address(this), amountIn);
        TransferHelper.safeApprove(tokenIn, address(swapRouter), amountIn);

        amountOut = swapRouter.exactInputSingle(ISwapRouter.ExactInputSingleParams({
            tokenIn : tokenIn,
            tokenOut : tokenOut,
            fee : PoolFee,
            recipient : address(this),
            deadline : block.timestamp,
            amountIn : amountIn,
            amountOutMinimum  : 0,
            sqrtPriceLimitX96 : 0
        }));
    }

    function LINKBalance() public view returns(uint256) {
        uint256 bal = IERC20(LINK).balanceOf(address(this));
        return bal;
    }

    function withdrawLINK() public {
        uint256 amount = IERC20(LINK).balanceOf(address(this));
        IERC20(LINK).transferFrom(address(this), msg.sender, amount);
    }
}
