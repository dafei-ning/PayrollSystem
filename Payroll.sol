pragma solidity ^0.4.25;

contract Payroll {
	address          owner;
	
	uint             salary       = 1 ether;
    address          employee     = 0xca35b7d915458ef540ade6068dfe2f44e8fa733c;
    uint    constant payDuration  = 30 days;
    uint             lastPayday   = now;

    function Payroll() {
        owner = msg.sender;
    }

    function addFund() payable returns(uint){
        return this.balance;
    }

    function calculateRunway() payable returns (uint) {
        return this.balance / salary;
    } 

    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() {
        if (lastPayday + payDuration > now) {
            revert();  // reverse the state and return the gas
        }
        lastPayday = lastPayday + payDuration; // the internal status change must come before external transfer
        employee.transfer(salary);
    }
}