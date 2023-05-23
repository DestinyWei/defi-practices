// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

// 此处补全
import "./02_PriceFeed.sol";
import "./02_WHM.sol";

contract CollateralStableCoin is ERC20 {
    using SafeMath for uint256;

    IERC20 public collateralToken; // 要抵押的币
    PriceFeed public priceFeed; // 价格预言机
    uint256 public amountOfCollateralToken; // 抵押币的总量
    uint256 public constant COLLATERAL_RATIO_PRECISION = 1e18;

    constructor(
        address _collateralToken,
        address _priceFeed
    ) ERC20("DAI", "DAI") {
        // 此处补全
        collateralToken = IERC20(_collateralToken);
        priceFeed = PriceFeed(_priceFeed);
    }

    function getCollateralPrice() public view returns (uint256) {
        // 此处补全
        int price = priceFeed.getLatestPrice();
        require(price > 0, "Invalid Price!");
        return uint(price);
    }

    function calculateCollateralAmount(
        uint256 _stablecoinAmount
    ) public view returns (uint256) {
        // 150% 超额抵押
        // 此处补全
        // 获取抵押品价格
        uint256 collateralPrice = getCollateralPrice();
        uint256 amount = _stablecoinAmount * 150 * COLLATERAL_RATIO_PRECISION / collateralPrice / 100; // 除以100是因为150是150%
        return amount;
    }

    function mint(uint256 _stablecoinAmount) external {
        // 此处补全
        // 检查数量是否合法
        require(_stablecoinAmount > 0, "Invalid amount!");
        // mint对应数量的DAI
        super._mint(msg.sender, _stablecoinAmount);
        // 充值对应比例数量的WHM
        uint256 collateralAmount = calculateCollateralAmount(_stablecoinAmount);
        amountOfCollateralToken += collateralAmount;
        collateralToken.transferFrom(msg.sender, address(this), collateralAmount);
    }

    function burn(uint256 _stablecoinAmount) external {
        // 此处补全
        // 检查数量是否合法
        require(_stablecoinAmount > 0 && _stablecoinAmount <= balanceOf(msg.sender), "Invalid amount!");
        // burn对应数量的DAI
        super._burn(msg.sender, _stablecoinAmount);
        // 提取对应比例数量的WHM
        uint256 collateralAmount = calculateCollateralAmount(_stablecoinAmount);
        amountOfCollateralToken -= collateralAmount;
        collateralToken.transfer(msg.sender, collateralAmount);
    }
}
