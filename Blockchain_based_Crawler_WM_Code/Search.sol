// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./WebCrawlerDriver.sol";

contract Search {
    WebCrawlerDriver public crawlerDriver;

    constructor(address driverAddress) {
        crawlerDriver = WebCrawlerDriver(driverAddress);
    }

    function search(string calldata keyword) external view returns (string memory) {
        return crawlerDriver.search(keyword);
    }
}
