// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0; // 컴파일러 버전

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "./SaleAnimalToken.sol";

contract MintAnimalToken is ERC721Enumerable {
    constructor() ERC721("somiAnimals", "SMA") {}

    mapping(uint256 => uint256) public animalTypeMap;

    struct AnimalTokenData {
        uint256 animalTokenId;
        uint256 animalType;
        uint256 animalPrice;
    }

    // AnimalTokenData[] public animalTokenDatas;
    SaleAnimalToken public saleAnimalTokenContract;

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

    function getAnimalTokenList(address _owner) view public returns(AnimalTokenData[] memory) {
        uint mintingCount = balanceOf(_owner);
        require(mintingCount != 0, "Owner did not animalToken"); // minting한 카드가 없는경우

        // mintingCount사이즈의 배열, new키워드로 선언되는 배열은 모두 메모리배열
        AnimalTokenData[] memory animalTokenDatas = new AnimalTokenData[](mintingCount);
        for(uint i = 0; i < mintingCount; i++) {
            uint256 animalTokenId = tokenOfOwnerByIndex(_owner, i);
            uint256 animalType = animalTypeMap[animalTokenId];
            uint256 animalPrice = saleAnimalTokenContract.getAnimalTokenPrice(animalTokenId);
            animalTokenDatas[i] = AnimalTokenData(animalTokenId, animalType, animalPrice);
        }
        return animalTokenDatas;
    }

    function setSaleAnimalTokenContract(address _saleAnimalToken) public {
        // 배포된 SaleAnimalToken 컨트랙트 주소를 이용해 SaleAnimalToken컨트랙트 가져오기
        saleAnimalTokenContract = SaleAnimalToken(_saleAnimalToken);
    }
}
