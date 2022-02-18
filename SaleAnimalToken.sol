// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
import "./MintAnimalToken.sol";

contract SaleAnimalToken {
    MintAnimalToken public mintAnimalTokenAddress;

    constructor(address _mintAnimalTokenaddress) {
        // MintAnimalToken컨트랙트 주소 할당
        mintAnimalTokenAddress = MintAnimalToken(_mintAnimalTokenaddress);
    }

    mapping(uint256 => uint256) priceMap;
    uint256[] public onSaleAnimalTokenIds;

    // 판매
    function SaleForAnimalToken(uint256 _animalTokenId, uint256 _price) public {
        address owner = mintAnimalTokenAddress.ownerOf(_animalTokenId);
        // 1. 소유권자가 현재 함수를 호출한 사람인지 확인
        // 2. 가격은 0이상으로 책정되어야 함
        // 3. 이미 판매중인 상품인지 확인
        // 4. Minting한 user가 SaleAnimalToken컨트랙트에 판매권을 줬는지 확인
        require(owner == msg.sender, "Caller is not animal token owner.");
        require(_price > 0, "Price must be at least zero.");
        require(
            priceMap[_animalTokenId] == 0,
            "This animal token is already on sale."
        );
        require(
            mintAnimalTokenAddress.isApprovedForAll(owner, address(this)),
            "Animal token owner did not approve token."
        );

        priceMap[_animalTokenId] = _price;
        onSaleAnimalTokenIds.push(_animalTokenId);
    }
}
