// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {ERC1155} from "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";

contract BlueCarbonCredit1155 is ERC1155, AccessControl {
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
    mapping(uint256 => string) public tokenURIs;

    event Retired(address indexed account, uint256 indexed id, uint256 value, string reason);

    constructor() ERC1155("") {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(AccessControl, ERC1155)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function setURI(uint256 id, string memory newuri) external onlyRole(MINTER_ROLE) {
        tokenURIs[id] = newuri;
    }

    function mint(address to, uint256 id, uint256 amount, bytes memory data) external onlyRole(MINTER_ROLE) {
        _mint(to, id, amount, data);
    }

    function retire(uint256 id, uint256 amount, string calldata reason) external {
        _burn(msg.sender, id, amount);
        emit Retired(msg.sender, id, amount, reason);
    }
}
