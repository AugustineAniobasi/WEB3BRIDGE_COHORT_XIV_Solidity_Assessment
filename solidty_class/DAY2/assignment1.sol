// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title ERC20 (from scratch, no libraries)
 * @notice Minimal, standards-compliant ERC-20 implementation with metadata.
 * @dev Includes: name, symbol, decimals, totalSupply, balanceOf, transfer,
 *      allowance, approve, transferFrom + optional increase/decreaseAllowance.
 */
contract ERC20 {
    // ----------- Events (ERC-20) -----------
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    // ----------- Storage -----------
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;
    uint8 private _decimals;

    // ----------- Constructor -----------
    constructor(string memory name_, string memory symbol_, uint8 decimals_) {
        _name = name_;
        _symbol = symbol_;
        _decimals = decimals_;
    }

    // ----------- ERC-20 Metadata -----------
    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public view returns (uint8) {
        return _decimals;
    }

    // ----------- ERC-20 Core -----------
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    /**
     * @notice Transfer tokens from msg.sender to `to`.
     */
    function transfer(address to, uint256 amount) public returns (bool) {
        _transfer(msg.sender, to, amount);
        return true;
    }

    /**
     * @notice Returns how many tokens `spender` can spend from `owner`.
     */
    function allowance(address owner, address spender) public view returns (uint256) {
        return _allowances[owner][spender];
    }

    /**
     * @notice Approve `spender` to spend `amount` from msg.sender.
     */
    function approve(address spender, uint256 amount) public returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    /**
     * @notice Transfer tokens from `from` to `to` using allowance from `from` to msg.sender.
     */
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

    // ----------- Optional Allowance Helpers -----------
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

    // ----------- Internal Logic -----------
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

    /**
     * @dev Internal mint function (you can expose this with access control if desired).
     */
    function _mint(address to, uint256 amount) internal {
        require(to != address(0), "ERC20: mint to zero");
        require(amount > 0, "ERC20: amount zero");

        _totalSupply += amount;
        _balances[to] += amount;

        emit Transfer(address(0), to, amount);
    }

    /**
     * @dev Internal burn function (you can expose this with access control if desired).
     */
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

/**
 * @title ExampleToken
 * @notice Example deployment that mints initial supply to deployer.
 * @dev Remove if you only want the base ERC20 contract.
 */
contract ExampleToken is ERC20 {
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

