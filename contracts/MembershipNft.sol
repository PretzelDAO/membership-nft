// contracts/MembershipNFT.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/drafts/Counters.sol";
import "@openzeppelin/contracts/ownership/Ownable.sol";

contract PretzelDAO_Membership is ERC721 {

    uint128 private membershipPriceInToken;
    uint128 private membershipYear;
    address membershipPriceTokenAddress;

    struct Whitelist {
        address addr;
        uint256 year;
        bool hasMinted;
    }
    mapping(address => Whitelist) public whitelist;
    address[] whitelistAddr;


    constructor(uint128 membershipPriceInToken, uint128 _membershipYear, address _membershipPriceTokenAddress) ERC721("PretzelDAO Membership", "MPRTZL") {
        membershipPriceInToken = membershipPriceInToken;
        membershipYear = _membershipPriceTokenAddress;
        membershipPriceTokenAddress = _membershipPriceTokenAddress;
    }

    function claimMembershipNft(address member) public returns (uint256) {
        require(!isWhitelisted(addr), "Not Whitelisted");
        ERC20(membershipPriceTokenAddress).transferFrom(msg.sender, address(this), membershipPriceInToken);
        _tokenIds.increment();
        uint256 membershipId = _tokenIds.current();
        _mint(member, membershipId);
        _setTokenUrI(membershipId, string(abi.encodePacked(membershipYear, '/', membershipId)));
    }

    function burnNft(uint256 _tokenId) public onlyOwner returns (uint256) {
        _burn(_tokenId);
    }

    function addAddressToWhitelist(address _addr) 
        public
        onlyOwner
        returns (bool success)
    {
        require(!isWhitelisted(addr), "Already whitelisted");
        whitelisted[_addr].addr = _addr;
        whitelist[_addr].year = membershipYear;
        whitelist[_addr].hasMinted = false;
        success = true;
    }

    function addAddressesToWhitelist(address[] memory _addrs) 
        public 
        onlyOwner
        returns (bool success)
    {
        for (unit256 i = 0; i < _addrs.length; i++) {
            addAddressToWhitelist(_addrs[i]);
        }
        success = true;
    }

    function isWhitelisted(address addr)
        public
        view
        returns (bool isWhitelisted)
    {
        return whitelist[addr].addr == addr && whitelist[addr].addr == addr;
    }

    function setMembershipPriceTokenAddress (uint256 _membershipPriceTokenAddress) 
        public 
        onlyOwner
    {
        membershipPriceTokenAddress = _membershipPriceTokenAddress;
    }

    function getMembershipPriceTokenAddress() public pure returns (uint256) {
        return membershipPriceTokenAddress;
    }

    function setMembershipYear (uint256 _membershipYear) 
        public 
        onlyOwner
    {
        membershipYear = _membershipYear;
    }

    function getMembershipYear() public pure returns (uint256) {
        return membershipYear;
    }

    function setMembershipPrice (uint256 _membershipPriceInToken) 
        public 
        onlyOwner
    {
        membershipPriceInToken = membershipPriceInToken;
    }

    function getMembershipPrice() public pure returns (uint256) {
        return membershipPriceInToken;
    }
}
