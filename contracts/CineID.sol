//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./token/ERC721/ERC721.sol";
import "./access/Ownable.sol";
import "./token/ERC721/extensions/ERC721URIStorage.sol";
import "./token/ERC721/extensions/ERC721Burnable.sol";

contract CineID is ERC721, ERC721URIStorage, ERC721Burnable, Ownable {
    constructor() ERC721("CineID", "CINEID") Ownable(msg.sender) {
    }

    function safeMint(address to, uint256 tokenId, string memory uri)
        public
        onlyOwner
    {
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
    
}
