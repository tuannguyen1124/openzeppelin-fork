//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./token/ERC20/ERC20.sol";
import "./access/Ownable.sol";

contract CineCoin is ERC20, Ownable {
    constructor() ERC20("Cinema Token", "CINECOIN") Ownable(msg.sender) {
//        _mint(msg.sender, 1000000 * 10 ** uint256(18));
    }

    function mint(address account, uint256 amount) public onlyOwner {
        _mint(account, amount);
    }

}
