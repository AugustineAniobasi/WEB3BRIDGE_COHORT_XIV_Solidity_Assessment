// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import {ECDSA} from "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract AuthorizationModule {

    using ECDSA for bytes32;

    mapping(address => bool) public isSigner;
    mapping(address => uint256) public nonces;

    bytes32 public DOMAIN_SEPARATOR;

    bytes32 public constant APPROVAL_TYPEHASH =
        keccak256(
            "Approve(bytes32 proposalId,uint256 nonce,uint256 deadline)"
        );

    constructor(address[] memory signers) {

        for(uint i=0;i<signers.length;i++){
            isSigner[signers[i]] = true;
        }

        DOMAIN_SEPARATOR = keccak256(
            abi.encode(
                keccak256(
                    "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
                ),
                keccak256(bytes("ARES")),
                keccak256(bytes("1")),
                block.chainid,
                address(this)
            )
        );
    }

    function verifyApproval(
        address signer,
        bytes32 proposalId,
        uint256 nonce,
        uint256 deadline,
        bytes calldata signature
    ) external returns (bool) {

        require(block.timestamp <= deadline, "SIGNATURE_EXPIRED");

        bytes32 digest = keccak256(
            abi.encodePacked(
                "\x19\x01",
                DOMAIN_SEPARATOR,
                keccak256(
                    abi.encode(
                        APPROVAL_TYPEHASH,
                        proposalId,
                        nonce,
                        deadline
                    )
                )
            )
        );

        address recovered = ECDSA.recover(digest, signature);

        require(recovered == signer, "INVALID_SIGNATURE");
        require(isSigner[signer], "NOT_SIGNER");
        require(nonce == nonces[signer], "INVALID_NONCE");

        nonces[signer]++;

        return true;
    }
}