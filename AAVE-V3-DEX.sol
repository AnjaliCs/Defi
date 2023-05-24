// SPDX-License-Identifier : MIT
pragma solidity^0.8.10;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";

/*------------------------------------------- AVALAUNCHE FUGI TESTNET --------------------------------------------------------*/
/*------------------- AAVE FLASHLOAN DEX V3 ----------------------*/

contract Dex {
    address payable public owner;
    address private immutable DAI = 0xE8BA4db946a310A1Aca92571A53D3bdE834B5409;
    address private immutable USDC = 0x6a17716Ce178e84835cfA73AbdB71cb455032456;

    IERC20 private dai;
    IERC20 private usdc;

    // Exchange Rates

    uint256 dexARate = 90;
    uint256 dexBRate = 100;

    mapping(address => uint256) daiBalance;
    mapping(address => uint256) usdcBalance;

    constructor() {
        owner = payable(msg.sender);
        dai = IERC20(DAI);
        usdc = IERC20(USDC);
    }

    receive() external payable {}

    function depositUSDC(uint256 _amount) external {
        usdcBalance[msg.sender] += _amount;
        uint256 allowance = usdc.allowance(msg.sender, address(this));
        require(allowance >= _amount, "Check the token allowance");
        usdc.transferFrom(msg.sender, address(this), _amount);
    }

    function depositDAI(uint256 _amount) external {
        daiBalance[msg.sender] += _amount;
        uint256 allowance = dai.allowance(msg.sender, address(this));
        require(allowance >= _amount, "check the token allowance");
        dai.transferFrom(msg.sender, address(this), _amount);
    
    }

    function buyDAI() public {
        uint256 daiToReceive = ((usdcBalance[msg.sender] / dexARate) * 100) * (10**12);
        dai.transfer(msg.sender, daiToReceive);
    }

    function sellDAI() public {
        uint256 usdcToReceive = ((daiBalance[msg.sender] * dexBRate) / 100) / (10**12);
        usdc.transfer(msg.sender, usdcToReceive);
    }


    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can execute");
        _;
    }

    function getBalance(address _assetAddress) public view returns(uint256) {
        uint256 balance = IERC20(_assetAddress).balanceOf(address(this));
        return balance;
    }

    function withdraw(address _assetAddress) public onlyOwner {
        IERC20 Token = IERC20(_assetAddress);
        Token.transfer(msg.sender, Token.balanceOf(address(this)));
    }

}
