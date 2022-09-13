// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;


contract ERC20 {
    event Print(address _from , uint _amount);
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
    //state
    mapping(address => uint256) private balances;
    mapping(address => mapping(address => uint256)) private allowances;
    uint256 private _totalSupply;


    string private _name;
    string private _symbol;
    uint8 private _decimal;

    constructor(){
        _name = "DREAM";
        _symbol = "DRM";
        _decimal = 18;
        _mint(msg.sender,100 ether);

    }

    function name() public view returns(string memory) {
        return _name;
    }
    function symbol() public view returns(string memory) {
        return _symbol;
    }
    function decimals() public view returns(uint8) {
        return _decimal;
    }


    function totalSupply() public view returns(uint) {
        return _totalSupply;
    }

    function transferFrom(address _from,address _to, uint256 _value) external  {
        require(msg.sender != address(0),"transfer from the zero address");
        require(_from != address(0),"transfer from the zero address");
        require(_to != address(0),"transfer to the zero address");

        uint256 currentAllowance = allowance(_from , msg.sender);
        require(currentAllowance >= _value , "Insufficient allowance");

 
        require(balances[_from] >= _value, "value exceeds balance");

        unchecked {
            balances[_from] -= _value;
            balances[_to] += _value;
            allowances[_from][msg.sender] -= _value;
        }

        emit Transfer(_from,_to,_value); 
        emit Print(msg.sender,balanceOf(msg.sender));
    }
    function allowance(address _owner , address _spender) public view returns(uint){
        return allowances[_owner][_spender];
    }

    function approve(address _spender,uint _amount) public  {

        require(msg.sender != address(0),"approve from the zero address");
        require(_spender != address(0),"approve to the zero address");
        require(_amount >= 0, "Underflow");

        address owner = msg.sender;
        unchecked {
            allowances[owner][_spender] = _amount;
        }

        emit Approval(owner,_spender,_amount);
    }

    function balanceOf(address _owner) public view returns(uint256) {
        return balances[_owner];
    }

    function transfer(address _to,uint256 _value) public{
        require(msg.sender != address(0),"transfer from the zero address");
        require(_to != address(0),"transfer to the zero address");
        require(balances[msg.sender] >= _value,"value exceeds balance");

        unchecked {

            balances[msg.sender] -= _value;
            balances[_to]+= _value;
        }

        emit Transfer(msg.sender,_to,_value); 
    }

    function _mint(address _to,uint _amount) public {
        require(_to != address(0),"_to is zero address");
        require(type(uint256).max >= _totalSupply+_amount);
        unchecked {

            balances[_to] += _amount;
            _totalSupply += _amount;
        }

        emit Transfer(address(0),_to,_amount);
    }

    function _burn(address _from,uint _amount) public {
        require(_from != address(0),"_from is zero address");
        require(balances[_from] >= _amount);
        unchecked {
            balances[_from] -= _amount;
            _totalSupply -= _amount;

        }

        emit Transfer(_from,address(0),_amount);

    }
}