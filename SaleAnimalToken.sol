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
    function saleForAnimalToken(uint256 _animalTokenId, uint256 _price) public {
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

    // 구매
    function purchaseAnimalToken(uint256 _animalTokenId) public payable {
        uint256 price = priceMap[_animalTokenId];
        address owner = mintAnimalTokenAddress.ownerOf(_animalTokenId);
        // 1. 판매중인 토큰인지 확인
        // 2. 거래금액(value)은 책정된 가격보다 작을 수 없음
        // 3. 소유권자는 구매 불가
        require(price > 0, "This animal token is not for sale.");
        require(msg.value >= price, "Caller sent lower than price.");
        require(owner != msg.sender, "Caller is animal token owner.");

        // 실제 코인거래
        payable(owner).transfer(msg.value); // 판매자에서 코인 전달
        mintAnimalTokenAddress.safeTransferFrom(owner, msg.sender, _animalTokenId);

        priceMap[_animalTokenId] = 0;
        // 판매중 토큰 id 제거
        for (uint256 i = 0; i < onSaleAnimalTokenIds.length; i++) {
            if (priceMap[onSaleAnimalTokenIds[i]] == 0) {
                // 해당 원소를 배열의 마지막원소로 대체후 마지막 원소 제거
                onSaleAnimalTokenIds[i] = onSaleAnimalTokenIds[
                    onSaleAnimalTokenIds.length - 1
                ];
                onSaleAnimalTokenIds.pop();
            }
        }
    }

    function getOnSaleAnimalTokenLength() public view returns (uint256) {
        return onSaleAnimalTokenIds.length;
    }
    function getAnimalTokenPrice(uint256 _animalTokenId) public view returns(uint256) {
        return priceMap[_animalTokenId];
    }
}
