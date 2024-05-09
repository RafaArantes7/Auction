// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "https://github.com/smartcontractkit/chainlink/blob/develop/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract MockFeed {
    function latestRoundData() 
    external view returns(uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound) {
        return (0, 100, 0, 0, 0);
    }
}

contract Oracle {
    
    AggregatorV3Interface feed;
    constructor(address priceFeed) {
        feed = AggregatorV3Interface(priceFeed);
    }

    function getPrice() public view returns(int256) {
        (uint80 roundId, int256 answer, uint256 stardedAt, uint256 updatedAt, uint80 answeredInRound) = feed.latestRoundData();
        return answer;
    }
}