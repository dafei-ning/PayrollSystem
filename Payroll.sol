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

    function updateEmployee(address e, uint s) {
        require(msg.sender == owner);
        if (employee != 0x0) {
            uint payment = salary * (now - lastPayday) / payDuration;
            employee.transfer(payment);
        }
        employee = e;
        salary = s * 1 ether;
        lastPayday = now;
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
        require(msg.sender == employee);
    	
        uint nextPayDay = lastPayday + payDuration;
        assert(nextPayDay < now);
        
        lastPayday = nextPayDay; // the internal status change must come before external transfer
        employee.transfer(salary);
    }
}