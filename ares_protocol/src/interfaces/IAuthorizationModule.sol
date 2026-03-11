// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

interface IAuthorizationModule {
    
    function isSigner(address account) external view returns (bool);

    function nonces(address account) external view returns (uint256);

    function DOMAIN_SEPARATOR() external view returns (bytes32);

    function APPROVAL_TYPEHASH() external view returns (bytes32);

    function verifyApproval(
        address signer,
        bytes32 proposalId, 
        uint256 nonce, 
        uint256 deadline, 
        bytes calldata signature
    ) external returns (bool);
}