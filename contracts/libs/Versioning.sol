//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";

/**
 * Versioning Library
 *
 * Versioning
 *
 * @author just-do-halee <just.do.halee@gmail.com>
 */
library Versioning {
    using SafeMath for uint256;

    struct Version {
        string[] detail;
    }

    event VersionTransferred(
        uint256 indexed newIndex,
        string indexed previousDetail,
        string indexed newDetail
    );

    function len(Version storage version)
        public
        view
        returns (uint256 _length)
    {
        _length = version.detail.length;
    }

    /**
     * Index Of
     *
     * -
     *
     * @param version version
     * @param _detail detail
     * @return int256 index
     */
    function indexOf(Version storage version, string memory _detail)
        public
        view
        returns (int256)
    {
        return _indexOf(version, _detail);
    }

    /**
     * Index Of
     *
     * -
     *
     * @param version version
     * @param _detail detail
     * @return int256 index
     */
    function _indexOf(Version storage version, string memory _detail)
        internal
        view
        returns (int256)
    {
        for (uint256 i = 0; i < len(version); i++) {
            if (
                keccak256(abi.encodePacked(version.detail[i])) ==
                keccak256(abi.encodePacked(_detail))
            ) {
                return int256(i);
            }
        }
        return -1;
    }

    /**
     * Detail Of
     *
     * -
     *
     * @param version version
     * @param _index index
     * @return string detail
     */
    function detailOf(Version storage version, uint256 _index)
        public
        view
        returns (string storage)
    {
        return _detailOf(version, _index);
    }

    /**
     * Detail Of
     *
     * -
     *
     * @param version version
     * @param _index index
     * @return _detail detail
     */
    function _detailOf(Version storage version, uint256 _index)
        internal
        view
        returns (string storage _detail)
    {
        _detail = version.detail[_index];
    }

    /**
     * Upgrade
     *
     * -
     *
     * @param version version
     * @param _detail detail
     * @return _index index
     */
    function upgrade(Version storage version, string memory _detail)
        public
        returns (uint256 _index)
    {
        string memory _previousDetail = version.detail[len(version)];

        version.detail.push(_detail);

        _index = len(version);

        emit VersionTransferred(_index, _previousDetail, _detail);
    }

    /**
     * Downgrade
     *
     * -
     *
     * @param version version
     * @param _index index
     * @return _detail detail
     */
    function downgrade(Version storage version, uint256 _index)
        public
        returns (string memory _detail)
    {
        uint256 previousLen = len(version);
        require(_index <= previousLen, "Out of bounds");

        string memory _previousDetail = version.detail[previousLen];

        for (uint256 i = 0; i < (previousLen + 1) - _index; i++) {
            version.detail.pop();
        }

        _detail = version.detail[_index];

        emit VersionTransferred(_index, _previousDetail, _detail);
    }
}
