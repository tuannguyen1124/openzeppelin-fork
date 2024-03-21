//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./token/ERC1155/ERC1155.sol";
import "./access/Ownable.sol";

contract CineTicket is ERC1155, Ownable {
    string public name;
    string public symbol;
    constructor(string memory _name, string memory _symbol) ERC1155("https://dev-cimena-api.io/api/v1/product/") Ownable(msg.sender) {
        name = _name;
        symbol = _symbol;
    }

    function mint(address to, uint256 id, uint256 value, bytes memory data) public onlyOwner {
        _mint(to, id, value, data);
    }

    function mintBatch(
        address to,
        uint256[] memory ids,
        uint256[] memory values,
        bytes memory data
    ) public onlyOwner {
        _mintBatch(to, ids, values, data);
    }

     function burn(
        address to,
        uint256 id,
        uint256 amount
    ) public onlyOwner{
        _burn(to, id, amount);
    }

    function burnBatch(
        address to,
        uint256[] memory ids,
        uint256[] memory values
    ) public onlyOwner {
        _burnBatch(to, ids, values);
     
    }

}
