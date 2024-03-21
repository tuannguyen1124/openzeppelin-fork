//SPDX-License-Identifier: MIT
pragma solidity ^0.8.5;

import "./interfaces/IERC721.sol";
import "./interfaces/IERC1155.sol";
import "./token/ERC1155/utils/ERC1155Holder.sol";
import "./utils/TransferHelper.sol";
import "./token/ERC20/ERC20.sol";
import "./token/ERC20/utils/SafeERC20.sol";
import "./access/Ownable.sol";
import "./utils/math/Math.sol";
import "./utils/cryptography/ECDSA.sol";
import "./CineID.sol";
import "./CineTicket.sol";
import "./CineCoin.sol";

contract Cinema is Ownable, ERC1155Holder {
    using ECDSA for bytes32;
    using SafeERC20 for ERC20;
    using Math for uint256;

    address public cineCoin;
    address public cineID;
    address public cineTicket;
    uint256 public priceTicket;

    // Events
    event ReleaseCineID(address userAddress, uint256 tokenId);
    event ReleaseCineTicket(uint256 id, uint256 value);
    event ReleaseCineCoin(uint256 amount);
    event BuyCineTicket(address buyer, uint256 tokenId,uint256 quantityTicket, uint256 amount);
 
    mapping(address => mapping(uint256 => bool)) public listUsedTicket;

    constructor(address _erc20, address _erc721, address _erc1155, uint256 _priceTicket) Ownable(msg.sender) {
        cineCoin = _erc20;
        cineID = _erc721;
        cineTicket = _erc1155;
        priceTicket = _priceTicket;
    }

    receive() external payable {}

    function setERC20Address(address _erc20) public onlyOwner {
        cineCoin = _erc20;
    }

    function setNFT1155Address(address _nft1155) public onlyOwner {
        cineTicket = _nft1155;
    }

    function setNFT721Address(address _nft721) public onlyOwner {
        cineID = _nft721;
    }

    function setPriceTicket(uint256 _priceTicket) public onlyOwner {
        priceTicket = _priceTicket;
    }


    function releaseCineID(address userAddress, uint256 tokenId, string memory uri) public onlyOwner {
        require(userAddress != address(0), "Invalid address");
        CineID(cineID).safeMint(userAddress, tokenId, uri);
        emit ReleaseCineID(userAddress, tokenId);
    }


    function releaseCineTicket(uint256 id, uint256 value) public onlyOwner {
        CineTicket(cineTicket).mint(address(this), id, value, "");
        emit ReleaseCineTicket(id, value);
    }

    function releaseCineCoin(uint256 amount) public onlyOwner {
        CineCoin(cineCoin).mint(address(this), amount);
        emit ReleaseCineCoin(amount);
    }

    function transferCineCoin(address to, uint256 amount) public onlyOwner {
        IERC20(cineCoin).transfer(to, amount);
    }

    function buyCineTicket(uint256 tokenId, uint256 quantityTicket) public {
        require(tokenId > 0, "TokenId must be greater than 0");
        require(quantityTicket > 0, "Amount must be greater than 0");
        require(IERC721(cineID).balanceOf(msg.sender) > 0, "User does not have cinema ID yet");
        uint256 amount = priceTicket * quantityTicket * 10**18;
        // check allowance of buyer
        require(IERC20(cineCoin).allowance(msg.sender, address(this)) >= amount, "Token allowance too low");

        // transfer token erc20 from seller to buyer
        ERC20(cineCoin).safeTransferFrom(msg.sender, address(this), amount);

        // transfer token from buyer to seller
        IERC1155(cineTicket).safeTransferFrom(address(this), msg.sender, tokenId, quantityTicket, "");

        emit BuyCineTicket(msg.sender, tokenId, quantityTicket, amount);
    }

    function usedTicket(address userAddress, uint256 tokenId) public onlyOwner {
        require(IERC1155(cineTicket).balanceOf(userAddress, tokenId) > 0, "User doesn't have ticket");
        listUsedTicket[userAddress][tokenId] = true;
    }
}
