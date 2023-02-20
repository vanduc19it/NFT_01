// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "./ERC721.sol";

//colectible smart contract to mint nft
contract VanDuc is ERC721 {
    
    string public name; // erc721 metadata
    string public symbol;// erc721 metadata
    
    uint256 public tokenCount;

    mapping(uint256 => string) private _tokenURIs;

    constructor( string memory _name, string memory _symbol) {
        name = _name;
        symbol = _symbol;
    }
    //return url of metadata of nFT by tokenID of nft
    function tokenURI(uint256 tokenId) public view returns(string memory) { // erc721 metadata
        require(_owners[tokenId] != address(0), "Token id does not exist");
        return _tokenURIs[tokenId];
    }

    function mint(string memory _tokenURI) public {
        tokenCount += 1; //contain tokenID and increase token count
        _balances[msg.sender] += 1;
        _owners[tokenCount] = msg.sender;
        _tokenURIs[tokenCount] = _tokenURI;


        //to recognize a NFT just minted = set address(0)
        emit Transfer(address(0),msg.sender, tokenCount);
    }

     function supportInterface(bytes4 interfaceID) public pure override returns(bool) {
        return interfaceID == 0x80ac58cd || interfaceID == 0x5b5e139f;
    }
   
}