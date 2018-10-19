pragma solidity ^0.4.25;

contract Payroll {
	address          owner;

	uint             salary       = 1 ether;
    address          employee     = 0x0;
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
    	if (msg.sender != employee) {
            revert();
        }
    	uint nextPayDay = lastPayday + payDuration;
        if (nextPayDay > now) {
            revert();  // reverse the state and return the gas
        }
        lastPayday = nextPayDay; // the internal status change must come before external transfer
        employee.transfer(salary);
    }
}