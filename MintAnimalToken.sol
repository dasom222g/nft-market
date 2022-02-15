// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0; // 컴파일러 버전

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract MintAnimalToken is ERC721Enumerable {
    constructor() ERC721("somiAnimals", "SMA") {}

    function mintAnimalToken() public {
        // 유일한 값
        uint256 animalTokenId = totalSupply() + 1;

        _mint(msg.sender, animalTokenId); // minting하기
    }
}
