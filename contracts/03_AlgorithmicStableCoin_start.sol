// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./03_PriceFeed.sol";

contract AlgorithmicStablecoin is ERC20, Ownable {
    PriceFeed internal priceFeed;

    uint256 public targetPrice = 1 * 10 ** 8; // Target price of 1 USD with 8 decimals
    uint256 public expansionPercentage = 5; // 5% expansion or contraction

    uint256 public lastPrice = 1;

    constructor(
        uint256 initialSupply,
        address _priceFeed
    ) ERC20("Algo LPL", "ALLPL") {
        // 补全
        super._mint(msg.sender, initialSupply);
        priceFeed = PriceFeed(_priceFeed);
    }

    function getLatestPrice() public view returns (uint256) {
        // 补全
        return priceFeed.getLatestPrice() / targetPrice;
    }

    function adjustSupply() public onlyOwner {
        // 补全
        uint256 latestPirce = getLatestPrice();
        // true -> 膨胀  flase -> 收缩
        bool flag = latestPirce > lastPrice ? true : false;
        if(flag) {
            uint256 amount = balanceOf(msg.sender) * 5 / 100;
            super._mint(msg.sender, amount);
        } else {
            uint256 amount = balanceOf(msg.sender) * 5 / 100;
            super._burn(msg.sender, amount);
        }
        lastPrice = latestPirce;
    }
}
