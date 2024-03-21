//SPDX-License-Identifier: MIT
pragma solidity ^0.8.5;

import "./interfaces/IERC721.sol";
import "./interfaces/IERC1155.sol";
import "./utils/TransferHelper.sol";
import "./token/ERC20/ERC20.sol";
import "./token/ERC20/utils/SafeERC20.sol";
import "./access/Ownable.sol";
import "./utils/math/Math.sol";
import "./utils/cryptography/ECDSA.sol";

contract ExchangeNFT is Ownable {
    using ECDSA for bytes32;
    using SafeERC20 for ERC20;
    using Math for uint256;

    address public ERC20Address;
    address public ERC721Address;
    address public ERC1155Address;

    // Events
    // addrs: from, to, token
    event BuyNFT721Normal(address buyer, address seller, uint256 amount, uint256 tokenId);
    event BuyNFT721ETH(address buyer, address seller, uint256 amount, uint256 tokenId);


    event BuyNFT1155Normal(address buyer, address seller, uint256 amount, uint256 tokenId, uint256 quantityToken);
    event BuyNFT1155ETH(address buyer, address seller, uint256 amount, uint256 tokenId, uint256 quantityToken);


    constructor(address _erc20, address _erc721, address _erc1155) Ownable(msg.sender) {
        ERC20Address = _erc20;
        ERC721Address = _erc721;
        ERC1155Address = _erc1155;
    }

    function setERC20Address(address _erc20) public onlyOwner {
        ERC20Address = _erc20;
    }

    function setNFT1155Address(address _nft1155) public onlyOwner {
        ERC1155Address = _nft1155;
    }

    function setNFT721Address(address _nft721) public onlyOwner {
        ERC721Address = _nft721;
    }


    // Buy NFT 721 by token ERC-20
    function buyNFT721Normal(address seller, uint256 amount, uint256 tokenId) external {
        require(amount > 0, "Amount must be greater than 0");
        require(tokenId > 0, "TokenId must be greater than 0");
        // check allowance of buyer
        require(IERC20(ERC20Address).allowance(msg.sender, address(this)) >= amount, "Token allowance too low");

        // transfer token erc20 from seller to buyer
        ERC20(ERC20Address).safeTransferFrom(msg.sender, seller, amount);

        // transfer token nft721 from buyer to seller
        IERC721(ERC721Address).safeTransferFrom(seller, msg.sender, tokenId);

        emit BuyNFT721Normal(msg.sender, seller, amount, tokenId);
    }

    // Buy NFT 1155 by token ERC-20
    function buyNFT1155Normal(address seller, uint256 amount, uint256 tokenId, uint256 quantityToken) external {
        require(amount > 0, "Amount must be greater than 0");
        require(tokenId > 0, "TokenId must be greater than 0");
        // check allowance of buyer
        require(IERC20(ERC20Address).allowance(msg.sender, address(this)) >= amount, "Token allowance too low");

        // transfer token erc20 from seller to buyer
        ERC20(ERC20Address).safeTransferFrom(msg.sender, seller, amount);

        // transfer token from buyer to seller
        IERC1155(ERC1155Address).safeTransferFrom(seller, msg.sender, tokenId, quantityToken, "");

        emit BuyNFT1155Normal(msg.sender, seller, amount, tokenId, quantityToken);
    }

    // Buy NFT 721 by ETH
    function buyNFT721ETH(address seller, uint256 amount, uint256 tokenId) external payable {
        require(amount > 0, "Amount must be greater than 0");
        require(tokenId > 0, "TokenId must be greater than 0");

        // transfer eth from buyer to seller
        TransferHelper.safeTransferETH(seller, amount);
        // transfer nft721 from seller to buyer
        IERC721(ERC721Address).safeTransferFrom(seller, msg.sender, tokenId);
        // refund dust eth, if any
        if (msg.value > amount)
            TransferHelper.safeTransferETH(msg.sender, msg.value - amount);
        emit BuyNFT721ETH(msg.sender, seller, amount, tokenId
);
    }

    // Buy NFT 1155 by ETH
    function buyNFT1155ETH(address seller, uint256 amount, uint256 tokenId, uint256 quantityToken) external payable {
        require(amount > 0, "Amount must be greater than 0");
        require(tokenId > 0, "TokenId must be greater than 0");
        
        // transfer eth from buyer to seller
        TransferHelper.safeTransferETH(seller, amount);

        // transfer nft1155 from seller to buyer
        IERC1155(ERC1155Address).safeTransferFrom(seller, msg.sender, tokenId, quantityToken, "");
        // refund dust eth, if any
        if (msg.value > amount)
            TransferHelper.safeTransferETH(msg.sender, msg.value - amount);
        emit BuyNFT1155ETH(msg.sender, seller, amount, tokenId, quantityToken);
    }
}
