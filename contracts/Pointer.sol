// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Pointer is Ownable {
    address private _addr;

    event AddressTransferred(
        address indexed previousAddress,
        address indexed newAddress
    );

    constructor(address __addr) {
        _addr = __addr;
        emit AddressTransferred(address(0), _addr);
    }

    /**
     * @dev Transfer target address
     * @param newAddress address of new target address
     */
    function transferAddress(address newAddress) public onlyOwner {
        _addr = newAddress;
        emit AddressTransferred(address(0), _addr);
    }

    /**
     * @dev Returns the target address
     */
    function addr() public view virtual returns (address) {
        return _addr;
    }
}
