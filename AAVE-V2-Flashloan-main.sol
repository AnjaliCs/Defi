// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;   

// Compiled at 0.6.12

import {FlashLoanReceiverBase} from "@aave/protocol-v2/contracts/flashloan/base/FlashLoanReceiverBase.sol";
import {ILendingPool} from "@aave/protocol-v2/contracts/interfaces/ILendingPool.sol";
import {ILendingPoolAddressesProvider} from "@aave/protocol-v2/contracts/interfaces/ILendingPoolAddressesProvider.sol";
import {IERC20} from "@aave/protocol-v2/contracts/dependencies/openzeppelin/contracts/IERC20.sol";


/*------------------------------------------- ETHEREUM GOERLI TESTNET --------------------------------------------------------*/
/*------------------- AAVE FLASHLOAN V2 ----------------------*/


contract FlashLoanV2 is FlashLoanReceiverBase {

    address owner;
    address DAI = 0x75Ab5AB1Eef154C0352Fc31D2428Cef80C7F8B33; // From AAVE FAUCET

    // To get some DAI or any ERC20 Tokens for AAAVE Testing - Go to https://app.aave.com/faucet/

    constructor(address _addressProvider) public
        FlashLoanReceiverBase(ILendingPoolAddressesProvider(_addressProvider)) {
        }


    /**
        This function is called after your contract has received the flash loaned amount
    **/

    modifier onlyOwner() {
        require(
            msg.sender == owner,
            "Only the contract owner can call this function"
        );
        _;
    }

    receive() external payable {}

    function executeOperation(
        address[] calldata assets,
        uint256[] calldata amounts,
        uint256[] calldata premiums,
        address initiator,
        bytes calldata params
    ) external override returns (bool) {
        
        // This contract now has the funds requested.
        // Your logic goes here.
        // At the end of your logic above, this contract owes
        // the flashloaned amounts + premiums.
        // Therefore ensure your contract has enough to repay
        // these amounts.

        // Approve the LendingPool contract allowance to *pull* the owed amount
        for (uint256 i = 0; i < assets.length; i++) {
            uint256 amountOwing = amounts[i].add(premiums[i]);
            IERC20(assets[i]).approve(address(LENDING_POOL), amountOwing);
        }
        return true;
    }


    function requestFlashLoan() public {
       
        address receiverAddress = address(this);
        address[] memory assets = new address[](1);
        assets[0] = DAI;
        uint256[] memory amounts = new uint256[](1);
        amounts[0] = 2000000000000000000;
        // 0 = no debt, 1 = stable, 2 = variable
        uint256[] memory modes = new uint256[](1);
        modes[0] = 0;
        address onBehalfOf = address(this);
        bytes memory params = "";
        uint16 referralCode = 0;

        IERC20(DAI).approve(address(LENDING_POOL), amounts[0]);

        LENDING_POOL.flashLoan(
            receiverAddress,
            assets,
            amounts,
            modes,
            onBehalfOf,
            params,
            referralCode
        );
    }

    function getBalance(address _tokenAddress) external view returns (uint256) {
        return IERC20(_tokenAddress).balanceOf(address(this));
    }

    function withdraw(address _tokenAddress) external onlyOwner {
        uint256 amt = IERC20(_tokenAddress).balanceOf(address(this));
        IERC20(_tokenAddress).approve(address(this), amt);
        msg.sender.transfer(amt);
    }
}
