// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 *@IERC20 contains functions my contract must implement
 *
 **/

interface IERC20 {

    function name() external view returns(string memory);
    function symbol() external view returns(string memory);
    function decimals() external view returns(uint8);
    function totalSupply() external view returns(uint256);
    function balanceOf(address _owner) external view returns(uint256 balance);
    function transfer(address _to, uint256 _value) external returns(bool success);
    function transferFrom(address _from, address _to, uint256 _value) external returns(bool success);
    function approve(address _spender, uint256 _value) external returns(bool success);
    function allowance(address _owner, address _spender) external view returns(uint256 remaining);

}
contract PacoinToken is IERC20 {

    string private _name;
    uint8 private _decimals;
    string private _symbol;
    uint256 private _totalSUpply;
    mapping[address => uint256] private _balances;

    constructor() {
        _name = "Pacoin";
        _decimals = 18;
        _symbol = "PAC";
        

    }

    /**
     *@name(), @symbol() and  @decimals()
     *The functions above are optional, you must not have them in an ERC20 token contract
     *@totalSupply(), @balanceOf(), @transfer(), @transferFrom(),@approve and @allowance
     *The functions above are compulsory, all ERC20 token contract must have them
     **/

    /**
     *@name(): returns the name of the token
     **/

    function name() public view returns(string memory) {
        return _name;
    }
 
    /**
     *@symbol(): returns the token symbol
     **/

    function symbol() public view returns(string memory) {
        return _symbol;
    }
    
    /**
     *@decimals(): display the number of decimal places the token uses
     **/

    function decimals() public view returns(uint8) {
        return _decimals;
    }

    /**
     *@totalSupply(): gives the total amount of token minted
     **/

    function totalSupply() public view returns(uint256) {

    return _totalSupply;

    }

    /**
    *@balanceOf(): returns the amount of token in a particular address
    **/
    
    function balanceOf(address _owner) public view returns(uint256 balance) {

        balance = _balances[_owner];
        return balance;

    } 

    /**
     *@transfer(): sends token to a specified address
     **/

    function transfer(address _to, uint256 _value) public returns(bool success) {

    require(_balances[_to] >= _value,"insufficient fund");
    require(_to != address(0),"Address not allowed to receive token");
    require(msg.sender != address(0),"Address zero not allowed to send token");

    _balances[msg.sender] = _balances[msg.sender] - _value;
    _balances[_to] = _balances[_to] + _value;

    return true;


    }

}


}
