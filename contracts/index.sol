// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "hardhat/console.sol";

/**
 * @title Owner
 * @dev Set & change owner
 */

 contract ecommerce {

     uint public coins = msg.value;
     
     struct Product {
         string title;
         string desc;
         address addr;
         address payable seller;
         uint productId;
         uint price;
         address buyer;
         bool delivered;
     }

        Product[] public Products;
        uint count = 1;
        event registered(string title, uint productId, address seller);
        event bought(string title, uint productId, address buyer);
        event deliverd(uint productId);


     function addProduct(string memory _title, string memory _desc, uint _price ) public {
         require(_price > 0, "plz set an amount for your product");
        Product memory newProduct;
         newProduct.title = _title;
         newProduct.desc = _desc;
         newProduct.price = _price * 10**18;
         newProduct.seller = payable(msg.sender);
         newProduct.productId = count;
        Products.push(newProduct);
        count++;
        emit registered(newProduct.title, newProduct.productId, msg.sender);
     }

     function buyProduct (uint id) payable public{
         require(Products[id-1].price <= msg.value, "you have not enough coins" );
         require(Products[id-1].seller != msg.sender, "you can not purchase your own product" );
         Products[id-1].buyer = msg.sender;
         emit bought(Products[id-1].title, id, msg.sender);
     }

     function delivered(uint id) public {

         require(Products[id-1].buyer == msg.sender, "buyer can only confirm the delivery!");
         Products[id-1].delivered = true;
         Products[id-1].seller.transfer(Products[id-1].price);
         emit deliverd(id);
     }
 }