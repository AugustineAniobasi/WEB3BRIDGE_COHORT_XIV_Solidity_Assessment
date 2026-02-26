// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 *@title IERC20 contains functions and Events any ERC20 token  must implement
 *@notice standard interface for ERC20 fungible token
 *@dev defines the required functions and events for ERC20 token
 */

interface IERC20 {

///@notice name()c, symbol(), decimals() are optional functions, you can choose to implement them or not.
    function name() external view returns(string memory);
    function symbol() external view returns(string memory);
    function decimals() external view returns(uint8);
    function totalSupply() external view returns(uint256);
    function balanceOf(address _owner) external view returns(uint256 balance);
    function transfer(address _to, uint256 _value) external returns(bool success);
    function transferFrom(address _from, address _to, uint256 _value) external returns(bool success);
    function approve(address _spender, uint256 _value) external returns(bool success);
    function allowance(address _owner, address _spender) external view returns(uint256 remaining);

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner,address indexed _spender, uint256 _value);

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
    uint256 private _totalSupply;
    address private _owner;

    mapping[address => uint256] private _balances;
    mapping[address => mapping[address => uint256] private _allowances;

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    constructor(uint256 _initSupply) {
        _name = "Pacoin";
        _decimals = 18;
        _symbol = "PAC";

        _owner = msg.sender;

        _mint(msg.sender, _initSupply)

    }

    function mint(address _to, uint256 _value) public onlyOwner returns(bool){
        _mint(_to,_value);
        return true;
    }

    modifier onlyOwner(){
        require(msg.sender == _owner, "Only the owner is allowed to call this function");
        _;
    }

    function getOwner() public returns(address){

        return _owner;
    }

    /**
     *@name(), @symbol() and  @decimals()
     *The functions above are optional, you must not have them in an ERC20 token contract
     *@totalSupply(), @balanceOf(), @transfer(), @transferFrom(),@approve and @allowance
     *The functions above are compulsory, all must be implemented
     */

   /// @notice Returns the Token name 'Pacoin'

    function name() public view returns(string memory) {
        return _name;
    }
 
    ///@notice Returns the Token symbol 'PAC'

    function symbol() public view returns(string memory) {
        return _symbol;
    }
    
    ///@notice Returns the number of decimals used by the token '18'

    function decimals() public view returns(uint8) {
        return _decimals;
    }

    ///@notice Returns the total token supplied

    function totalSupply() public view returns(uint256) {

    return _totalSupply;

    }

    ///@balanceOf Returns the amount of token owned by a specific address
    
    function balanceOf(address _account) public view returns(uint256 balance) {

        return  _balances[_account];
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

        _transfer(msg.sender, _to, _value);

        return true;
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

        _transfer(_from, _to, _value);

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
     *@param _account the address that gives approval for a certain amount of token to be spent
     *@param _spender the address responsible for spending the approved token
     *@return displays the allowance left from the approved token
     */


    function allowance(address _account, address _spender) public view returns(uint256 remaining) {

        remaining = _allowances[_account][_spender];
    }
    /**
     *@notice a helper function used to transfer token from one account to another
     *@dev _from account is increased by the value of the token
     *     _to account is decreased by the value of the token
     *      Emits a {Transfer} event if successful
     *param _from address of account token is transferred from
     *param _to address of account token is transferred to
     *

    function _transfer(address _from, address _to,uint256 _value) private {
        
        _balances[_from] = _balances[_from] - _value;
        _balances[_to] = _balances[_to] + _value;

        emit Transfer(_from, _to,_value);

    }
    
    function _mint(address _to, uint256 _value) private {
    
        _balances[_to] = _balances[_to] + _value;
        _totalSupply = _totalSupply + _value;

        emit Transfer(address(0), _to, _value);

    }
    



}
