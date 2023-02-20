// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

contract ERC721 {
     event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);

    event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);

    event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);

    mapping(address => uint256 ) internal _balances;
    mapping(uint256 => address) internal _owners;
    mapping(address => mapping(address => bool)) private _operatorApprovals; //nested mapping
    mapping(uint256 => address) private _tokenApprovals;

    //return amounts of NFTs of an user
    function balanceOf(address owner) external view returns (uint256) {
        require(owner != address(0), "Address zero");
        return _balances[owner];
    }   

    //Find owner of NFT when have id NFT
    function ownerOf(uint256 tokenId) public view returns (address) {
        address owner = _owners[tokenId];
        require(owner != address(0), "Token ID does not exist"); // if address 0 is nft is burnt.
        return owner;
    }
    //allow: enable or disable an operator, aprove for operator manage your nfts
    function setApprovalForAll(address operator, bool approved) external {
        _operatorApprovals[msg.sender][operator] = approved;
        emit ApprovalForAll(msg.sender, operator, approved);
    }

    //check if an address is an operator of another address
    function isApprovedForAll(address owner, address operator) public view returns (bool){
        return _operatorApprovals[owner][operator];
    }

    // allow for an nft of an address
    function approve(address approved, uint256 tokenId) public payable {
        address owner = ownerOf(tokenId);
        require(msg.sender == owner || isApprovedForAll(owner, msg.sender), "msg.sender is not the owner or the approved operator");
        _tokenApprovals[tokenId] = approved;
        emit Approval(owner, approved, tokenId);
    }

    //get the approved for an nft
    function getApproved(uint256 tokenId) public view returns (address) {
        require(_owners[tokenId] != address(0), "Token id does not exist");
        return _tokenApprovals[tokenId];
    }

    //tranfer ownership from adress to other address
    function transferFrom(address from, address to, uint256 tokenId) public payable {
        address owner = ownerOf(tokenId);

        require(
            //owner or operator or a adress have owner authorization 
            msg.sender == owner ||
            getApproved(tokenId) == msg.sender ||  
            isApprovedForAll(owner, msg.sender),
            "msg.sender is not the owner or approved for tranfers"
        );
        require(owner == from, "from address is not the owner");
        require(to != address(0), "Address is zero");
        require(_owners[tokenId] != address(0), "Token id does not exist");

        approve(address(0), tokenId);
        _balances[from] -= 1;
         _balances[to] += 1;
        _owners[tokenId] = to;

        emit Transfer(from, to, tokenId);
    }
    
    // is a tranfer function have implement feature receiver has capability to receice token or not because can lost nft 
    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public payable {
        transferFrom(from, to, tokenId);
        require(_checkOnERC721Received(), "Receiver not implement ");
    }

    function _checkOnERC721Received() private pure returns(bool) {
        return true;
    }

    
    function safeTransferFrom(address from, address to, uint256 tokenId) external payable {
        safeTransferFrom(from, to, tokenId, "");
    }

    //EIP165 proposal : query if a contract implement another interface
    function supportsInterface(bytes4 interfaceID) public pure virtual returns(bool) {
        return interfaceID == 0x80ac58cd;
    }
   


// interface ERC165 {
  
//     function supportsInterface(bytes4 interfaceID) external view returns (bool);
// }

// interface ERC721TokenReceiver {
   
//     function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes _data) external returns(bytes4);
// }

// interface ERC721Metadata /* is ERC721 */ {
   
//     function name() external view returns (string _name);

    
//     function symbol() external view returns (string _symbol);

   
//     function tokenURI(uint256 _tokenId) external view returns (string);
// }
}