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
function balanceOf() external view returns(uint256 balance);
function transfer(address _to, uint256 _value) external returns(bool success);
function transferFrom(address _from, address _to, uint256 _value) external returns(bool success);
function approve(address _spender, uint256 _value) external returns(bool success);
function allowance(address _owner, address _spender) external view returns(uint256 remaining);

}
contract PacoinToken is IERC20 {

string private _name;
string private _decimals;
string private _symbol;
uint256 private _totalSUpply;

constructor() {

}

/**
 *
 *@name(), symbol(), decimals() are optional functions
 *@totalSupply(),transfer(),transferFrom(),approve(),balanceOf() and allowance()
 *Are all compulsory functions that must be implemented in every ERC20 token
 *
 **/

function name() public view returns(string memory) {
    return _name;
} 

function symbol() public view returns(string memory) {
    return _symbol;
}

function decimals() public view returns(uint8) {
    return _decimals;

function totalSupply() public view returns(uint256) {
    return _totalSupply;
}

}


}
