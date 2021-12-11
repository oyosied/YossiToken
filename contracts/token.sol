pragma solidity ^0.8.4;
 
//Safe Math Interface
 
contract SafeMath {
 
    function safeAdd(uint a, uint b) public pure returns (uint c) {
        c = a + b;
        require(c >= a);
    }
 
    function safeSub(uint a, uint b) public pure returns (uint c) {
        require(b <= a);
        c = a - b;
    }
 
    function safeMul(uint a, uint b) public pure returns (uint c) {
        c = a * b;
        require(a == 0 || c / a == b);
    }
 
    function safeDiv(uint a, uint b) public pure returns (uint c) {
        require(b > 0);
        c = a / b;
    }
}
 
//Actual token contract


interface IERC20 {
  function totalSupply() external view returns (uint256);

  function balanceOf(address who) external view returns (uint256);

  function allowance(address owner, address spender)
    external view returns (uint256);

  function transfer(address to, uint256 value) external returns (bool);

  function approve(address spender, uint256 value)
    external returns (bool);

  function transferFrom(address from, address to, uint256 value)
    external returns (bool);

  event Transfer(
    address indexed from,
    address indexed to,
    uint256 value
  );

  event Approval(
    address indexed owner,
    address indexed spender,
    uint256 value
  );
}

contract YossiToken is IERC20,SafeMath{
    uint256 public _totalSupply;
    uint256 _balanceOf;
    string public _name;
    string public symbol;
    uint8 _decimals=0;
    mapping(address => uint256) _balances;
    mapping(address => mapping (address => uint256)) _allowed;
    
    constructor(){
        _name = "YossiToken";
        symbol="YTC2";
        _decimals = 0;
        _totalSupply = 100000;
        _balances[msg.sender] = _totalSupply;
        emit Transfer(address(0), msg.sender, _totalSupply);
    }
    function name() public view virtual returns (string memory){
        return _name;
    }
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }
    function balanceOf(address tokenOwner) public view returns (uint) {
        return _balances[tokenOwner];
    }
    function transfer(address to,uint256 value) public returns(bool){
        require(value <= _balances[msg.sender]);
        require(to != address(0));
        _balances[msg.sender] = safeSub(_balances[msg.sender],value);
        _balances[to]=safeAdd(_balances[to],value);
        emit Transfer(msg.sender,to,value);
        return true;
    }
    function allowance(address owner,address spender) public view returns(uint256){
        return _allowed[owner][spender];

    }
    function approve(address spender,uint256 value) public returns (bool){
        require(spender != address(0));
        _allowed[msg.sender][spender]=value;
        emit Approval(msg.sender, spender, value);
        return true;
    }
    function transferFrom(address from,address to,uint256 value) public returns(bool){
         require(value <= _balances[from]);
        require(value <= _allowed[from][msg.sender]);
        require(to != address(0));

        _balances[from] = _balances[from]-value;
        _balances[to] = _balances[to]+value;
        _allowed[from][msg.sender] = _allowed[from][msg.sender]-value;
        emit Transfer(from, to, value);
        return true;
    }
    fallback() external{
    }
}
