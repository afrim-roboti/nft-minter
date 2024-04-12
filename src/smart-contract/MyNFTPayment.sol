// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/finance/PaymentSplitter.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract MyNFTPayment is PaymentSplitter, Ownable {

    mapping(address => uint256) private _payeesShares;
    address[] private _payeesAddress;

    constructor(address[] memory payees, uint256[] memory shares, address initialOwner) 
    PaymentSplitter(payees, shares) 
    Ownable(initialOwner) 
    payable {
    for (uint256 i = 0; i < payees.length; i++) {
        _addMyPayee(payees[i], shares[i]);
    }
}
    
    /*
        Only Owner 
        Modify addresses and payees, send parameter addresses, shares, removeOld
    */

    function modifyPayees(address[] memory payeesAddresses, uint256[] memory payeesShares, bool removeOld) public onlyOwner
    {
        if(removeOld) {
            _deleteShareHolders();
        }

        for (uint256 i = 0; i < payeesAddresses.length; i++) {
            _addMyPayee(payeesAddresses[i], payeesShares[i]);
        }
    }


    function _addMyPayee(address account, uint256 _shares) private {
        require(account != address(0), "PaymentSplitter: account is the zero address");
        require(_shares > 0, "PaymentSplitter: shares are 0");
        require(_payeesShares[account] == 0, "PaymentSplitter: account already has shares");
        _payeesAddress.push(account);
        _payeesShares[account] = _shares;
    }


    function _deleteShareHolders() private {
        for (uint256 i = 0; i < _payeesAddress.length; i++) {
             delete _payeesShares[_payeesAddress[i]];
        }
        delete _payeesAddress;
    }

}





