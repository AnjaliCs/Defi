// SPDX-License-Identifier : UNLICENSED
pragma solidity^0.8.10;

import {FlashLoanSimpleReceiverBase} from "@aave/core-v3/contracts/flashloan/base/FlashLoanSimpleReceiverBase.sol";
import {IPoolAddressesProvider} from "@aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol";
import {IERC20} from "@aave/core-v3/contracts/dependencies/openzeppelin/contracts/IERC20.sol";

/*------------------------------------------- AVALAUNCHE FUGI TESTNET --------------------------------------------------------*/
/*------------------- AAVE FLASHLOAN V3 ----------------------*/

contract Flashloan is FlashLoanSimpleReceiverBase {

    address payable owner;
    address DAI = 0xE8BA4db946a310A1Aca92571A53D3bdE834B5409; 

    /* PoolAddressProvider - 0x220c6A7D868FC38ECB47d5E69b99e9906300286A */

    constructor(address _addressProvider) FlashLoanSimpleReceiverBase(IPoolAddressesProvider(_addressProvider)) {
        owner = payable(msg.sender);
    }

    receive() external payable {}

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can execute");
        _;
    }

    // To get some DAI or any ERC20 Tokens for AAAVE Testing - Go to https://app.aave.com/faucet/

    function executeOperation(
        address asset,
        uint256 amount, 
        uint256 premium,
        address initiator,
        bytes calldata params
    ) external override returns(bool) {
        
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

    function getBalance(address _tokenAddress) external view returns (uint256) {
        return IERC20(_tokenAddress).balanceOf(address(this));
    }

    function checkDAI() public view returns(uint256) {
        uint256 balance = IERC20(DAI).balanceOf(address(this));
        return balance;
    }

    function withdraw(address _tokenAddress) external onlyOwner {
        IERC20 Token = IERC20(_tokenAddress);
        Token.transfer(msg.sender, Token.balanceOf(_tokenAddress)); 
    }
}
