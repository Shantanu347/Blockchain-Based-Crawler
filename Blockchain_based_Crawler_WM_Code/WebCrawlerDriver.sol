// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./WebCrawler.sol";

contract WebCrawlerDriver {
    WebCrawler public crawler;

    constructor(address crawlerAddress) {
        crawler = WebCrawler(crawlerAddress);
    }

    function search(string calldata keyword) external view returns (string memory)
    {
        string memory crawledData = crawler.getCrawledData();
        string memory trainedData = crawler.getTrainedData();

        string memory results = "";
        if (bytes(crawledData).length > 0 && bytes(trainedData).length > 0) {
            results = string(
                abi.encodePacked(
                    "Crawled data:\n",
                    crawledData,
                    "\n\nTrained data:\n",
                    trainedData
                )
            );
            if (bytes(keyword).length > 0) {
                // Search for the keyword in the crawled and trained data
                bool crawledMatch = bytes(crawledData).length >=
                    bytes(keyword).length &&
                    bytes(crawledData)[32] == bytes(keyword)[0] &&
                    bytes(crawledData)[32 + bytes(keyword).length] ==
                    bytes(keyword)[bytes(keyword).length - 1];
                bool trainedMatch = bytes(trainedData).length >=
                    bytes(keyword).length &&
                    bytes(trainedData)[32] == bytes(keyword)[0] &&
                    bytes(trainedData)[32 + bytes(keyword).length] ==
                    bytes(keyword)[bytes(keyword).length - 1];
                if (crawledMatch || trainedMatch) {
                    results = string(
                        abi.encodePacked(
                            results,
                            "\n\nResults for '",
                            keyword,
                            "':\n"
                        )
                    );
                    if (crawledMatch) {
                        uint256 crawledIndex = bytes(crawledData).length;
                        while (crawledIndex > 0) {
                            crawledIndex--;
                            if (
                                bytes(crawledData)[crawledIndex] ==
                                bytes(keyword)[bytes(keyword).length - 1] &&
                                bytes(crawledData)[
                                    crawledIndex - bytes(keyword).length + 1
                                ] ==
                                bytes(keyword)[0]
                            ) {
                                uint256 start = crawledIndex -
                                    bytes(keyword).length +
                                    1;
                                uint256 end = crawledIndex + 1;
                                while (
                                    start > 0 &&
                                    bytes(crawledData)[start - 1] != "\n"
                                ) {
                                    start--;
                                }
                                while (
                                    end < bytes(crawledData).length &&
                                    bytes(crawledData)[end] != "\n"
                                ) {
                                    end++;
                                }
                                //results = string(abi.encodePacked(results, "\n- ", bytes(crawledData)[start:uint256(end)]));
                                /*results = string(
                                    abi.encodePacked(
                                        results,
                                        "\n- ",
                                        bytes(crawledData)[start:start + end]
                                    )
                                );*/
                                bytes memory trainedDataBytes = bytes(
                                    trainedData
                                );
                                uint256 chunkSize = 32;
                                // string memory results;

                                for (
                                    uint256 i = 0;
                                    i < trainedDataBytes.length;
                                    i += chunkSize
                                ) {
                                    bytes32 chunk;
                                    assembly {
                                        chunk := mload(
                                            add(trainedDataBytes, add(i, 32))
                                        )
                                    }
                                    results = string(
                                        abi.encodePacked(results, "\n- ", chunk)
                                    );
                                }
                            }
                        }
                    }
                    if (trainedMatch) {
                        uint256 trainedIndex = bytes(trainedData).length;
                        while (trainedIndex > 0) {
                            trainedIndex--;
                            if (
                                bytes(trainedData)[trainedIndex] ==
                                bytes(keyword)[bytes(keyword).length - 1] &&
                                bytes(trainedData)[
                                    trainedIndex - bytes(keyword).length + 1
                                ] ==
                                bytes(keyword)[0]
                            ) {
                                uint256 start = trainedIndex -
                                    bytes(keyword).length +
                                    1;
                                uint256 end = trainedIndex + 1;
                                while (
                                    start > 0 &&
                                    bytes(trainedData)[start - 1] != "\n"
                                ) {
                                    start--;
                                }
                                while (
                                    end < bytes(trainedData).length &&
                                    bytes(trainedData)[end] != "\n"
                                ) {
                                    end++;
                                }
                                //results = string(abi.encodePacked(results, "\n- ", bytes(trainedData)[start:end]));
                                bytes memory trainedDataBytes = bytes(
                                    trainedData
                                );
                                uint256 chunkSize = 32;
                                // string memory results1;

                                for (
                                    uint256 i = 0;
                                    i < trainedDataBytes.length;
                                    i += chunkSize
                                ) {
                                    bytes32 chunk;
                                    assembly {
                                        chunk := mload(
                                            add(trainedDataBytes, add(i, 32))
                                        )
                                    }
                                    results = string(
                                        abi.encodePacked(results, "\n- ", chunk)
                                    );
                                }
                            }
                        }
                    }
                }
            }
        }
        return results;
    }

}
