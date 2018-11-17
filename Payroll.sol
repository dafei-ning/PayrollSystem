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

    function _partialPaid(Employee employee) {
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.id.transfer(payment);
    }

    function _findEmployee(address employeeID) returns (Employee) {
        for (uint i = 0; i < employees.length; i++) {
            if (employees[i].id == employeeID) {
                return employees[i];
            }
        }
    }

    function addEmployee(address employeeID, uint salary) {
        require(msg.sender == owner);
        Employee employee = _findEmployee(employeeID);
        employees.push(Employee(employee, salary, now));
    }

    function removeEmployee(address employeeID) {
        require(msg.sender == owner);
        for (uint i = 0; i < employees.length; i++) {
            if (employees[i].id == employee) {
                _partialPaid(employees[i]);
                delete employees[i];  // delete以后位置是空白的，不太便于日后操作
                employees[i] = employees[employees.length - 1]; // 一个技巧是将最后一个employee提到被删的那个位置上
                employees.length -= 1; // 然后将数组size缩小
                return;
            }
        }
    }

    function updateEmployee(address employeeID, uint salary) {
        require(msg.sender == owner);
        for (uint i = 0; i < employees.length; i++) {
            if (employees[i].id == employeeID) {
                _partialPaid(employees[i]);
                employees[i].salary = salary;
                employees[i].lastPayday = now;
                return;
            }
        }
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