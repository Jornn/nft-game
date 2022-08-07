// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NftGame is ERC721, Ownable {
    uint256 maxSupply;

    constructor(
        string memory _name,
        string memory _symbol,
        uint256 _maxSupply
    ) ERC721(_name, _symbol) {
        maxSupply = _maxSupply;
    }

    struct Character {
        string name;
        uint256 id;
        uint256 lives;
        uint256 level;
    }

    uint256 counter;

    Character[] public characters;

    event NewCharacter(address indexed owner, uint256 id, uint256 lives);

    function _createRandomNumber(uint256 _mod) internal view returns (uint256) {
        uint256 randomNum = uint256(
            keccak256(abi.encodePacked(block.timestamp, msg.sender))
        );
        return randomNum % _mod;
    }

    function createCharacter(string memory _name) external {
        require(counter < maxSupply, "Max supply reached");
        uint256 randLives = _createRandomNumber(10);
        Character memory newCharacter = Character(
            _name,
            counter,
            randLives + 1,
            1
        );
        characters.push(newCharacter);
        _safeMint(msg.sender, counter);
        emit NewCharacter(msg.sender, counter, randLives);
        counter++;
    }

    function getCharacter(uint256 _id) public view returns (Character memory) {
        return characters[_id];
    }

    function getCharacterLevel(uint256 _id) public view returns (uint256) {
        return characters[_id].level;
    }

    function getCharacterLives(uint256 _id) public view returns (uint256) {
        return characters[_id].lives;
    }

    function getAllCharacters() public view returns (Character[] memory) {
        return characters;
    }

    function getCharacterCount() public view returns (uint256) {
        return counter;
    }

    function levelup(uint256 _id) external {
        require(
            msg.sender == ownerOf(_id),
            "You are not the owner of this token"
        );
        require(characters[_id].level < 10, "You have reached the max level");
        uint256 randomNumber = _createRandomNumber(2);

        if (randomNumber == 0) {
            characters[_id].level++;
        } else {
            characters[_id].lives--;
            if (characters[_id].lives == 0) {
                _burn(_id);
            }
        }
    }
}
