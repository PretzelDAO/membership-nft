// contracts/MembershipNFT.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract PretzelDAO_Membership is ERC721URIStorage, ERC721Enumerable, Ownable {

    uint256 private membershipPriceInToken;
    uint256 private membershipYear;
    address membershipPriceTokenAddress;

    struct Whitelist {
        address addr;
        uint256 year;
        bool hasMinted;
    }
    mapping(address => Whitelist) public whitelist;
    address[] whitelistAddr;

    constructor(uint256 _membershipPriceInToken, uint256 _membershipYear, address _membershipPriceTokenAddress, address _multisignOwner) ERC721("PretzelDAO Membership", "MPRTZL") {
        membershipPriceInToken = _membershipPriceInToken;
        membershipYear = _membershipYear;
        membershipPriceTokenAddress = _membershipPriceTokenAddress;
        // Give Control to our MultiSig
        transferOwnership(_multisignOwner);
    }

    function claimMembershipNft(address member) public returns (uint256) {
        require(!isWhitelisted(member), "Not Whitelisted");
        IERC20 erc20 = IERC20(membershipPriceTokenAddress);
        erc20.transferFrom(msg.sender, address(this), membershipPriceInToken);
        uint256 membershipId = totalSupply();
        _mint(member, membershipId);
        _setTokenURI(membershipId, string(abi.encodePacked(membershipYear, '/', membershipId)));
        return membershipId;
    }

    function burnNft(uint256 _tokenId) 
        public 
        onlyOwner 
        returns (uint256) 
    {
        _burn(_tokenId);
        return _tokenId;
    }

    function addAddressToWhitelist(address _addr) 
        public
        onlyOwner
    {
        require(!isWhitelisted(_addr), "Already whitelisted");
        whitelist[_addr].addr = _addr;
        whitelist[_addr].year = membershipYear;
        whitelist[_addr].hasMinted = false;
    }

    function addAddressesToWhitelist(address[] memory _addrs) 
        public 
        onlyOwner
    {
        for (uint256 i = 0; i < _addrs.length; i++) {
            addAddressToWhitelist(_addrs[i]);
        }
    }

    function isWhitelisted(address addr)
        public
        view
        returns (bool whitelisted)
    {
        return whitelist[addr].addr == addr && whitelist[addr].year == membershipYear && !whitelist[addr].hasMinted;
    }

    function setMembershipPriceTokenAddress (address _membershipPriceTokenAddress) 
        public 
        onlyOwner
    {
        membershipPriceTokenAddress = _membershipPriceTokenAddress;
    }

    function getMembershipPriceTokenAddress() 
        public 
        view 
        returns (address) 
    {
        return membershipPriceTokenAddress;
    }

    function setMembershipYear (uint256 _membershipYear) 
        public 
        onlyOwner
    {
        membershipYear = _membershipYear;
    }

    function getMembershipYear() 
        public 
        view
        returns (uint256) 
    {
        return membershipYear;
    }

    function setMembershipPrice (uint256 _membershipPriceInToken) 
        public 
        onlyOwner
    {
        membershipPriceInToken = _membershipPriceInToken;
    }

    function getMembershipPrice() 
        public 
        view
        returns (uint256) 
    {
        return membershipPriceInToken;
    }

    // Needed because of interhitance
    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    // Needed because of interhitance
    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    // Needed because of interhitance
    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    // Needed because of interhitance
    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
