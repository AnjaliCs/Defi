// SPDX-License-Identifier : MIT
pragma solidity^0.8.0;

import "https://github.com/smartcontractkit/chainlink/blob/develop/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract PriceV3Consumer {

    AggregatorV3Interface internal priceFeed;

    constructor() {
        priceFeed = AggregatorV3Interface(0xA39434A63A52E749F02807ae27335515BA4b07F7);  // BTC/USD
    }

    function getLatestPrice() public view returns(int) {
        (,int price,,,) = priceFeed.latestRoundData();
        return price;
    }
}
