// contracts/MembershipNFT.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract PretzelDAO_Membership is IERC721Metadata, ERC721Enumerable, Ownable {
    uint256 private membershipPriceInToken;
    uint256 private membershipYear;
    string baseURI;
    address membershipPriceTokenAddress;
    address whitelistDelegate;

    struct Whitelist {
        address addr;
        uint256 year;
        bool hasMinted;
    }
    mapping(address => Whitelist) public whitelist;
    address[] whitelistAddr;

    constructor(
        uint256 _membershipPriceInToken,
        uint256 _membershipYear,
        address _membershipPriceTokenAddress,
        address _multisignOwner,
        address _whitelistDelegate
    ) ERC721("PretzelDAO Membership", "MPRTZL") {
        membershipPriceInToken = _membershipPriceInToken;
        membershipYear = _membershipYear;
        membershipPriceTokenAddress = _membershipPriceTokenAddress;
        whitelistDelegate = _whitelistDelegate;
        // Give Control to our MultiSig
        transferOwnership(_multisignOwner);
    }

    modifier allowedToWhitelist() {
        require(owner() == _msgSender() || whitelistDelegate == _msgSender());
        _;
    }

    function claimMembershipNft(address member) public returns (uint256) {
        require(isWhitelisted(member), "Not Whitelisted");
        IERC20 erc20 = IERC20(membershipPriceTokenAddress);
        erc20.approve(address(this), membershipPriceInToken);
        erc20.transferFrom(msg.sender, address(this), membershipPriceInToken);
        uint256 membershipId = totalSupply();
        _mint(member, membershipId);
        return membershipId;
    }

    function burnNft(uint256 _tokenId) public onlyOwner returns (uint256) {
        _burn(_tokenId);
        return _tokenId;
    }

    function addAddressToWhitelist(address _addr) public allowedToWhitelist {
        require(!isWhitelisted(_addr), "Already whitelisted");
        whitelist[_addr].addr = _addr;
        whitelist[_addr].year = membershipYear;
        whitelist[_addr].hasMinted = false;
    }

    function addAddressesToWhitelist(address[] memory _addrs)
        public
        allowedToWhitelist
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
        return
            whitelist[addr].addr == addr &&
            whitelist[addr].year == membershipYear &&
            whitelist[addr].hasMinted == false;
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, IERC721Metadata)
        returns (string memory)
    {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );

        return
            bytes(baseURI).length > 0
                ? string(
                    abi.encodePacked(
                        baseURI,
                        Strings.toString(membershipYear),
                        "/",
                        Strings.toString(tokenId)
                    )
                )
                : "";
    }

    function setWhitelistDelegate(address _whitelistDelegate) public onlyOwner {
        whitelistDelegate = _whitelistDelegate;
    }

    function getWhitelistDelegate() public view returns (address) {
        return whitelistDelegate;
    }

    function setMembershipPriceTokenAddress(
        address _membershipPriceTokenAddress
    ) public onlyOwner {
        membershipPriceTokenAddress = _membershipPriceTokenAddress;
    }

    function getMembershipPriceTokenAddress() public view returns (address) {
        return membershipPriceTokenAddress;
    }

    function setMembershipYear(uint256 _membershipYear) public onlyOwner {
        membershipYear = _membershipYear;
    }

    function getMembershipYear() public view returns (uint256) {
        return membershipYear;
    }

    function setMembershipPrice(uint256 _membershipPriceInToken)
        public
        onlyOwner
    {
        membershipPriceInToken = _membershipPriceInToken;
    }

    function setBaseUri(string memory _baseUri)
        public
        onlyOwner
    {
        baseURI = _baseUri;
    }

    function getMembershipPrice() public view returns (uint256) {
        return membershipPriceInToken;
    }

    // make token soulbound
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override(ERC721, IERC721) {
        require(false, "Token is Soulbound");
        return;
    }

    // make token soulbound
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) public virtual override(ERC721, IERC721) {
        require(false, "Token is Soulbound");
        return;
    }
}
