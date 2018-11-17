pragma solidity ^0.4.25;

contract Payroll {

    struct Employee {
        address id;
        uint    salary;
        uint    lastPayday;

    }

    address          owner;
    uint    constant payDuration  = 30 days;
    Employee[]       employees;


    function Payroll() {
        owner = msg.sender;
    }

    function addEmployee(address employee, uint salary) {
        require(msg.sender == owner);
        for (uint i = 0; i < employees.length; i++) {
            if (employees[i].id == employee) {
                revert("The employee address exists in database!")
            }
        }
        employees.push(Employee(employee, salary, now));
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