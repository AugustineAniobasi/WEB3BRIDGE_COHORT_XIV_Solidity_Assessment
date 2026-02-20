// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;


contract ERC20 {
    
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;
    uint8 private _decimals;

    constructor(string memory name_, string memory symbol_, uint8 decimals_) {
        _name = name_;
        _symbol = symbol_;
        _decimals = decimals_;
    }

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public view returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    function transfer(address to, uint256 amount) public returns (bool) {
        _transfer(msg.sender, to, amount);
        return true;
    }

    function allowance(address owner, address spender) public view returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) public returns (bool) {
        uint256 currentAllowance = _allowances[from][msg.sender];
        require(currentAllowance >= amount, "ERC20: insufficient allowance");

        // Decrease allowance (standard behavior)
        unchecked {
            _approve(from, msg.sender, currentAllowance - amount);
        }

        _transfer(from, to, amount);
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
        _approve(msg.sender, spender, _allowances[msg.sender][spender] + addedValue);
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
        uint256 currentAllowance = _allowances[msg.sender][spender];
        require(currentAllowance >= subtractedValue, "ERC20: decreased below zero");
        unchecked {
            _approve(msg.sender, spender, currentAllowance - subtractedValue);
        }
        return true;
    }

    function _transfer(address from, address to, uint256 amount) internal {
        require(from != address(0), "ERC20: transfer from zero");
        require(to != address(0), "ERC20: transfer to zero");
        require(amount > 0, "ERC20: amount zero");

        uint256 fromBal = _balances[from];
        require(fromBal >= amount, "ERC20: insufficient balance");

        unchecked {
            _balances[from] = fromBal - amount;
        }
        _balances[to] += amount;

        emit Transfer(from, to, amount);
    }

    function _approve(address owner, address spender, uint256 amount) internal {
        require(owner != address(0), "ERC20: approve from zero");
        require(spender != address(0), "ERC20: approve to zero");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _mint(address to, uint256 amount) internal {
        require(to != address(0), "ERC20: mint to zero");
        require(amount > 0, "ERC20: amount zero");

        _totalSupply += amount;
        _balances[to] += amount;

        emit Transfer(address(0), to, amount);
    }

    function _burn(address from, uint256 amount) internal {
        require(from != address(0), "ERC20: burn from zero");
        require(amount > 0, "ERC20: amount zero");

        uint256 fromBal = _balances[from];
        require(fromBal >= amount, "ERC20: burn exceeds balance");

        unchecked {
            _balances[from] = fromBal - amount;
        }
        _totalSupply -= amount;

        emit Transfer(from, address(0), amount);
    }
}

contract MyToken is ERC20 {
    constructor(
        string memory name_,
        string memory symbol_,
        uint8 decimals_,
        uint256 initialSupply_
    ) ERC20(name_, symbol_, decimals_) {
        // initialSupply_ is in the smallest unit (like wei for ETH)
        _mint(msg.sender, initialSupply_);
    }
}


contract SaveEther is ERC 20,MyToken{
    mapping(address => uint256) public balances;

    mapping(address => uint256) public TokenBalances;

    event DepositSuccessful(address indexed sender, uint256 indexed amount);

    event WithdrawalSuccessful(address indexed receiver, uint256 indexed amount, bytes data);

    function deposit() external payable {
        // require(msg.sender != address(0), "Address zero detected");
        require(msg.value > 0, "Can't deposit zero value");

        balances[msg.sender] = balances[msg.sender] + msg.value;

        emit DepositSuccessful(msg.sender, msg.value);
    }

     function depositToken() external payable {
        // require(msg.sender != address(0), "Address zero detected");
        require(msg.value > 0, "Can't deposit zero value");

        TokenBalances[msg.sender] = TokenBalances[msg.sender] + msg.value;

    }

    function withdraw(uint256 _amount) external {
        require(msg.sender != address(0), "Address zero detected");

        // the balance mapping is a key to value pair, if the key is
        // provided it retuns the value at that location.
        //
        uint256 userSavings_ = balances[msg.sender];

        require(userSavings_ > 0, "Insufficient funds");

        balances[msg.sender] = userSavings_ - _amount;

        // (bool result,) = msg.sender.call{value: msg.value}("");
        (bool result, bytes memory data) = payable(msg.sender).call{value: _amount}("");

        require(result, "transfer failed");

        emit WithdrawalSuccessful(msg.sender, _amount, data);
    }

      function withdrawToken(uint256 _tokenAmount) external {
        require(msg.sender != address(0), "Address zero detected");

        // the balance mapping is a key to value pair, if the key is
        // provided it retuns the value at that location.
        //
        uint256 userSavings2_ = TokenBalances[msg.sender];

        require(userSavings2_ > 0, "Insufficient funds");

        Tokenbalances[msg.sender] = userSavings2_ - _tokenamount;

        // (bool result,) = msg.sender.call{value: msg.value}("");
        (bool result, bytes memory data) = (msg.sender).call{value: _tokenamount}("");

        require(result, "transfer failed");

    }

    function getUserSavings() external view returns (uint256) {
        return balances[msg.sender];
    }

    function getContractBalance() external view returns (uint256) {
        return address(this).balance;
    }

    receive() external payable {}
    fallback() external {}
}