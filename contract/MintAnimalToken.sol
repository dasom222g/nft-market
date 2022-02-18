// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0; // 컴파일러 버전

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract MintAnimalToken is ERC721Enumerable {
    constructor() ERC721("somiAnimals", "SMA") {}

    mapping(uint256 => uint256) public animalTypeMap;

    function mintAnimalToken() public {
        uint256 animalTokenId = totalSupply() + 1; // 유일한 값
        // %5 : 0 ~ 4
        // +1 : 1 ~ 5
        uint256 animalType = (uint256(
            keccak256(
                abi.encodePacked(block.timestamp, animalTokenId, msg.sender)
            )
        ) % 5) + 1;
        animalTypeMap[animalTokenId] = animalType;

        _mint(msg.sender, animalTokenId); // minting하기
    }
}
