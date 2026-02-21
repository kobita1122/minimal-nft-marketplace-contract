# Minimal NFT Marketplace Contract

A robust and secure smart contract designed for peer-to-peer NFT trading. This repository provides the core logic for a fixed-price NFT marketplace where users can list their digital assets for sale using Ether.

## Features
* **Listing Management:** Sellers can list NFTs by providing the contract address and Token ID.
* **Secure Escrow:** The contract handles the transfer of ownership only when the correct payment is received.
* **Cancellation:** Sellers can delist their NFTs at any time before a sale occurs.
* **Reentrancy Protection:** Built with OpenZeppelin's security standards to prevent common exploits.

## Architecture
The marketplace acts as a trusted intermediary. When an NFT is listed, the seller must approve the marketplace contract to transfer the token. When a buyer calls the `buyItem` function, the contract transfers the funds to the seller and the NFT to the buyer in a single atomic transaction.



## Deployment
1. Install dependencies: `npm install`
2. Compile the contract: `npx hardhat compile`
3. Deploy to your preferred network (Ethereum, Polygon, Base, etc.).

## License
MIT
