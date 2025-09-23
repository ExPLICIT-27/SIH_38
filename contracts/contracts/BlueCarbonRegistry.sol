// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";

contract BlueCarbonRegistry is AccessControl {
    bytes32 public constant ANCHOR_ROLE = keccak256("ANCHOR_ROLE");

    event Anchored(string uploadId, bytes32 sha256Hash, string cid, address indexed by);

    constructor() {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(ANCHOR_ROLE, msg.sender);
    }

    function anchor(string calldata uploadId, bytes32 sha256Hash, string calldata cid) external onlyRole(ANCHOR_ROLE) {
        emit Anchored(uploadId, sha256Hash, cid, msg.sender);
    }
}


