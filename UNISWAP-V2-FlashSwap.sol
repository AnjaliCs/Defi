// SPDX-License-Identifier : MIT;
pragma solidity^0.8.17;

interface IUniswapV2Callee {
    function uniswapV2Call(address sender, uint256 amount0, uint256 amount1, bytes calldata data) external;
}

interface IUniswapV2Pair {
    function swap(uint256 amount0Out, uint256 amount1Out, address to, bytes calldata data) external;
}

interface IUniswapV2Factory {
    function getPair(address tokenA, address tokenB) external view returns(address pair);
}

interface IERC20 {
    function totalSupply() external view returns(uint256);
    function balanceOf(address account) external view returns(uint256);
    function approve(address spender, uint256 amount) external returns(bool);
    function allowance(address owner, address spender) external view returns(uint256);
    function transfer(address to, uint256 amount) external returns(bool);
    function transferFrom(address from, address to, uint256 amount) external returns(bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

interface IWETH is IERC20 {
    function deposit() external payable;
    function withdraw(uint256 amount) external;
}


/*----------------------------------- ETHEREUM GOERLI TESTNET ---------------------------*/


abstract contract UniswapV2Flashswap is IUniswapV2Callee {
    address UniswapV2_Factory = address(0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f);
    address WETH = address(0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6);
    address DAI = address(0x75Ab5AB1Eef154C0352Fc31D2428Cef80C7F8B33);

    IUniswapV2Factory private Factory = IUniswapV2Factory(UniswapV2_Factory);
    IERC20 private weth = IERC20(WETH);

    IUniswapV2Pair private immutable pair;
    uint256 public amountToRepay;

    
    constructor() {
        pair = IUniswapV2Pair(Factory.getPair(DAI, WETH));
    }

    function flashswap(uint256 wethAmount) external {
        bytes memory data = abi.encode(WETH, msg.sender);
        pair.swap(0, wethAmount, address(this), data);
    }

    function UniswapV2Call(
        address sender, 
        uint256 amount0, 
        uint256 amount1, 
        bytes calldata data) external {
            require(msg.sender == address(pair), "This is not the pair  contract");
            require(sender == address(this), "Sender should be the current contract");

            (address tokenBorrowed, address caller) = abi.decode(data, (address, address));
            uint fee =  (amount1  * 3)/ 997 + 1;
            amountToRepay = amount1 + fee;
            weth.transferFrom(caller, address(this), fee);
            weth.transfer(address(pair), amountToRepay);
    }
    
}
