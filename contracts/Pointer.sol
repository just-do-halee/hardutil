// SPDX-License-Identifier: MIT
// Hardutil Contracts v0.0.1 (Pointer.sol)

pragma solidity ^0.8.0;

import "hardhat/console.sol";

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

import "./libs/Versioning.sol";

abstract contract LockableContract {
    // for checking if owner is the same owner
    function owner() public view virtual returns (address);

    // for locking previous contract
    function lock() public virtual;
}

/**
 * Pointer Contract
 *
 * This contract will keep tracking an specific address.
 * And has versioning event too.
 *
 * @author just-do-halee <just.do.halee@gmail.com>
 */
abstract contract Pointer is Ownable {
    using SafeMath for uint256;
    using Address for address;

    using Versioning for Versioning.Version;
    Versioning.Version private version;

    modifier isContract(address _address) {
        require(_address.isContract(), "Address is not for a contract");
        require(
            LockableContract(_address).owner() == owner(),
            "Caller is not the owner"
        );
        _;
    }

    event AddressTransferred(
        uint256 indexed index,
        address indexed previousAddress,
        address indexed newAddress
    );

    address[] private _addresses;

    constructor(address _address) isContract(_address) {
        _addresses.push(_address);
        emit AddressTransferred(_addresses.length.sub(1), address(0), _address);
        version.upgrade("0.0.1");

        console.log("initilized 0.0.1,", _address);
    }

    /**
     * @dev Transfer target address
     * @param newAddress address of new target address
     */
    function transferAddress(address newAddress, string memory versionDetail)
        public
        onlyOwner
        isContract(newAddress)
    {
        LockableContract(addr()).lock();

        _addresses.push(newAddress);
        emit AddressTransferred(
            _addresses.length.sub(1),
            _addresses[_addresses.length.sub(2)],
            newAddress
        );

        version.upgrade(versionDetail);
    }

    /**
     * @dev Returns the target address
     */
    function addr() public view virtual returns (address) {
        return _addresses[_addresses.length.sub(1)];
    }

    /**
     * @dev Returns the length of target address array
     */
    function len() public view returns (uint256 _length) {
        _length = _addresses.length;
    }

    /**
     * Index Of Target Address
     *
     *
     * @param _address address
     * @return int256 index
     */
    function indexOfAddress(address _address) public view returns (int256) {
        return _indexOfAddress(_address);
    }

    /**
     * Index Of Target Address
     *
     *
     * @param _address address
     * @return int256 index
     */
    function _indexOfAddress(address _address) internal view returns (int256) {
        for (uint256 i = 0; i < _addresses.length; i++) {
            if (_addresses[i] == _address) {
                return int256(i);
            }
        }
        return -1;
    }

    /**
     * Index Of Version Detail
     *
     * -
     *
     * @param _detail detail
     * @return _index index
     */
    function indexOfVersionDetail(string memory _detail)
        public
        view
        returns (int256 _index)
    {
        _index = _indexOfVersionDetail(_detail);
    }

    /**
     * Index Of Version Detail
     *
     * -
     *
     * @param _detail detail
     * @return _index index
     */
    function _indexOfVersionDetail(string memory _detail)
        internal
        view
        returns (int256 _index)
    {
        _index = version.indexOf(_detail);
    }
}
