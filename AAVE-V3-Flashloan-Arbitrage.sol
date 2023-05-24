// SPDX-License-Identifier : MI
pragma solidity^0.8.0;

import {FlashLoanSimpleReceiverBase} from "@aave/core-v3/contracts/flashloan/base/FlashLoanSimpleReceiverBase.sol";
import {IPoolAddressesProvider} from "@aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol";
import {IERC20} from "@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol";

/*------------------------------------------- AVALAUNCHE FUGI TESTNET --------------------------------------------------------*/
/*------------------- FLASHLOAN ARBITRAGE AAVE V3 ----------------------*/

interface IDex {
    function depositDAI(uint256 _amount) external;
    function depositUSDC(uint256 _amount) external;
    function buyDAI() external;
    function sellDAI() external;
}

contract FlashLoanArbitrage is FlashLoanSimpleReceiverBase {
    address payable owner;
    address private immutable DAI = 0xE8BA4db946a310A1Aca92571A53D3bdE834B5409;
    address private immutable USDC = 0x6a17716Ce178e84835cfA73AbdB71cb455032456;
    address private DEX = 0xB9D5Fe80B9C07bE0f617416b7267ea029194Fa73;

    IERC20 private dai;
    IERC20 private usdc;
    IDex private dex; 

    /* PoolAddressProvider - 0x220c6A7D868FC38ECB47d5E69b99e9906300286A */

    constructor(address _addressProvider) FlashLoanSimpleReceiverBase(IPoolAddressesProvider(_addressProvider)) {
        owner = payable(msg.sender);
        dai = IERC20(DAI);
        usdc = IERC20(USDC);
        dex = IDex(DEX);
    }

    receive() external payable {}

    function executeOperation(
        address asset,
        uint256 amount,
        uint256 premium,
        address initiator,
        bytes calldata params
    ) external override returns(bool) {

        dex.depositUSDC(5000000);
        dex.buyDAI();
        dex.depositDAI(dai.balanceOf(address(this)));
        dex.sellDAI();

        uint256 amountOwed = amount + premium;
        IERC20(asset).approve(address(POOL), amountOwed);
        return true;
    }


    function requestFlashloan(address _token, uint256 _amount) public {
        address receiverAddress = address(this);
        address asset = _token;
        uint256 amount = _amount;
        bytes memory params = "";
        uint16 referralCode = 0;

        POOL.flashLoanSimple(receiverAddress, asset, amount, params, referralCode);
    }


    function approveUSDC(uint256 _amount) external returns(bool) {
        return usdc.approve(DEX, _amount);
    }

    function USDCAllowance() external view returns(uint256) {
        return usdc.allowance(address(this), DEX);
    }

    function approveDAI(uint256 _amount) external returns(bool) {
        return dai.approve(DEX, _amount);
    }

    function DAIAllowance() external view returns(uint256) {
        return dai.allowance(address(this), DEX);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can execute.");
        _;
    }

    function checkUSDC() public view returns(uint256) {
        uint256 balance = usdc.balanceOf(address(this));
        return balance;
    }

    function checkDAI() public view returns(uint256) {
        uint256 balance = dai.balanceOf(address(this));
        return balance;
    }

    function withdraw(address _tokenAddress) public {
        IERC20 Token = IERC20(_tokenAddress);
        Token.transfer(msg.sender, Token.balanceOf(address(this)));
    }
}
