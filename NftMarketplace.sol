// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract NftMarketplace is ReentrancyGuard {
    struct Listing {
        address seller;
        address nftContract;
        uint256 tokenId;
        uint256 price;
        bool active;
    }

    // Mapping from Listing ID to Listing details
    mapping(uint256 => Listing) private s_listings;
    uint256 private s_listingCounter;

    event ItemListed(uint256 indexed listingId, address indexed seller, address indexed nftContract, uint256 tokenId, uint256 price);
    event ItemSold(uint256 indexed listingId, address indexed buyer, uint256 price);
    event ListingCanceled(uint256 indexed listingId);

    // List an NFT for sale
    function listItem(address nftContract, uint256 tokenId, uint256 price) external {
        require(price > 0, "Price must be at least 1 wei");
        IERC721 nft = IERC721(nftContract);
        require(nft.ownerOf(tokenId) == msg.sender, "Not the owner");
        require(nft.isApprovedForAll(msg.sender, address(this)), "Marketplace not approved");

        s_listingCounter++;
        s_listings[s_listingCounter] = Listing(msg.sender, nftContract, tokenId, price, true);

        emit ItemListed(s_listingCounter, msg.sender, nftContract, tokenId, price);
    }

    // Purchase a listed NFT
    function buyItem(uint256 listingId) external payable nonReentrant {
        Listing storage listing = s_listings[listingId];
        require(listing.active, "Listing not active");
        require(msg.value >= listing.price, "Insufficient funds");

        listing.active = false;
        
        // Transfer NFT to buyer
        IERC721(listing.nftContract).safeTransferFrom(listing.seller, msg.sender, listing.tokenId);
        
        // Transfer funds to seller
        (bool success, ) = payable(listing.seller).call{value: msg.value}("");
        require(success, "Transfer failed");

        emit ItemSold(listingId, msg.sender, listing.price);
    }

    // Cancel a listing
    function cancelListing(uint256 listingId) external {
        Listing storage listing = s_listings[listingId];
        require(listing.seller == msg.sender, "Not the seller");
        require(listing.active, "Listing not active");

        listing.active = false;
        emit ListingCanceled(listingId);
    }

    function getListing(uint256 listingId) external view returns (Listing memory) {
        return s_listings[listingId];
    }
}
