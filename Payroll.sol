pragma solidity ^0.4.25;

contract Payroll {
	uint             salary       = 1 ether;
    address          employee     = 0xca35b7d915458ef540ade6068dfe2f44e8fa733c;
    uint    constant payDuration  = 30 days;
    uint             lastPayday   = now;

    function Payroll() {
        
    }

    function addFund() returns(uint){
        return this.balance;
    }

    function calculateRunway() returns (uint) {
        
    } 

    function hasEnoughFund() returns (bool) {
        
    }

    function getPaid() {
        
    }
}