// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 *@title IERC20 contains functions my contract must implement
 *@notice standard interface for ERC20 fungible token
 *@dev defines the required functions and events for ERC20 token
 */

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

/**
 *@title PacoinToken
 *@notice Implement the ERC20 standard for PacoinToken
 *@dev includes standard approval, allowance and transfer mechanism
 *     implement the IERC20 token interface with 18 decimals
 */


contract PacoinToken is IERC20 {

    string private _name;
    uint8 private _decimals;
    string private _symbol;
    uint256 private _totalSUpply;

    mapping[address => uint256] private _balances;
    mapping[address => mapping[address => uint256] private _allowances;

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    constructor() {
        _name = "Pacoin";
        _decimals = 18;
        _symbol = "PAC";
        

    }

    /**
     *@name(), @symbol() and  @decimals()
     *The functions above are optional, you must not have them in an ERC20 token contract
     *@totalSupply(), @balanceOf(), @transfer(), @transferFrom(),@approve and @allowance
     *The functions above are compulsory, all must be implemented
     */

    /**
     *@notice display the token name
     *@return gives the name of the token
     */

    function name() public view returns(string memory) {
        return _name;
    }
 
    /**
     *@notice display the token symbol
     *@return gives the token symbol
     */

    function symbol() public view returns(string memory) {
        return _symbol;
    }
    
    /**
     *@notice display the number of  decimal places used by the Token
     *@return the number of decimal place used by the token
     */

    function decimals() public view returns(uint8) {
        return _decimals;
    }

    /**
     *@notice Give the total amount of token minted
     *@return Gives the total amount of token minted
     */

    function totalSupply() public view returns(uint256) {

    return _totalSupply;

    }

    /**
     *@notice gets the balance of '_owner'
     *@return displays the balance of '_owner'
     */
    
    function balanceOf(address _owner) public view returns(uint256 balance) {

        return  _balances[_owner];
    } 

    /**
     *@notice transfer token from 'msg.sender' to '_to'
     *@dev the caller must have sufficient token to transfer
     *      Ensures address zero doesn't interact with the contract
     *      reduces the caller token by '_value'
     *      increase the '_to' by value
     *@param _to address Token is transferred to
     *@param _value The amount of token transferred
     *@return True if the transaction is complete
     **/

    function transfer(address _to, uint256 _value) public returns(bool success) {
        require(_balances[msg.sender] >= _value,"insufficient fund");
        require(_to != address(0),"Address not allowed to receive token");
        require(msg.sender != address(0),"Address zero not allowed to send token");

        _balances[msg.sender] = _balances[msg.sender] - _value;
        _balances[_to] = _balances[_to] + _value;

        return true;

        emit Transfer(msg.sender, _to, _value);
    }
    
    /**
     *@notice transfer approved tokens from one address '_from' to another address '_to'
     *@dev the caller must have sufficient allowance from '_from'
     *@param _from The address from which token are withdrawn
     *@param _to The address receiving the token
     *@param _value The amount of token transferred
     *@return success True if the transfer completes successfully
     */

    function transferFrom(address _from, address _to, uint256 _value) public returns(bool success) {
        require(_allowances[_from][msg.sender] >= _value,"Token not yet approved for spending");

        _balances[_from] = _balances[_from] - _value;
        _balnces[_to] = _balances[_to] + _value;

        _allowances[_from][msg.sender] = _allowances[_from][msg.sender] - _value;

        return true;
    }

    /**
     *@notice approves an address to spend a certain amount of the callers token
     *@dev the callers balance must be greater than the token approved
     *     Emits a {Approval} event if successful
     *@return True if the approval completes
     */

    
    function approve(address _spender, uint _value) public returns(bool success) {
        require(_balances[msg.sender] >= _value,"insufficient funds to approve");

        _allowances[msg.sender][_spender] = _value 

        return true;
    
        emit Transfer(msg.sender, _spender, _value);
    }

    /**
     *@notice display amount of token left from the approved Tokemn
     *@param _owner the address that gives approval for a certain amount of token to be spent
     *@param _spender the address responsible for spending the approved token
     *@return displays the allowance left from the approved token
     */


    function allowance(address _owner, address _spender) public view returns(uint256 remaining) {

        remaining = _allowances[_owner][_spender];
    }
