//SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract RetailStore {

    // Retail Store  Record structure
    struct ProductRecord {
        string productName;
        string productDescription;
        string productQuantity;
        uint timestamp;
    }

    // Product structure
    struct Product {
        string name;
        mapping(uint => ProductRecord) productRecords;
        bool isPaid;
    }

    // User structure
    struct User {
        string id;
        string name;
        string speciality;
    }

    // Mapping to store Product information
    mapping(address => Product) public products;

    // Mapping to store  user  information
    mapping(address => User) public users;

    // Function to Register User
    function registerUser(string memory _id, string memory _name, string memory _speciality) public {
        users[msg.sender] = User(_id, _name, _speciality);
    }

    // Function to make payment
    function makePayment() public payable {
        Product storage product = products[msg.sender];
        require(product.isPaid == false, "payment already made");
        require(keccak256(abi.encodePacked(product.name)) != keccak256(abi.encodePacked("")), "Product not registered");
        product.isPaid = true;
    }

    // Function to add user record
    function addProductRecord(uint _productRecordId, address productAddress, string memory _productName, string memory _productDescription, string memory _productQuantity) public {
    // only User can add products record
    User memory user = users[msg.sender];
    require(bytes(user.id).length > 0, "Only user can add products record.");
    // user id should be valid
    Product storage product = products[productAddress];
    require(product.productRecords[_productRecordId].timestamp == 0, "Product ID Invalid");
    uint timestamp = block.timestamp;
    ProductRecord memory record = ProductRecord(_productName, _productDescription, _productQuantity, timestamp);
    product.productRecords[_productRecordId] = record;
    product.name = _productName;
}

    // Function to get product record
    function getProductRecord(address _productAddress, uint _productId) public view returns (string memory, string memory, string memory, uint) {
        Product storage product = products[_productAddress];
        ProductRecord memory record = product.productRecords[_productId];
        return (record.productName, record.productDescription, record.productQuantity, record.timestamp);
    }

}
