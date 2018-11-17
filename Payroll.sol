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

    function _partialPaid(Employee employee) private {
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.id.transfer(payment);
    }

    function _findEmployee(address employeeID) private returns (Employee, uint) {
        for (uint i = 0; i < employees.length; i++) {
            if (employees[i].id == employeeID) {
                return (employees[i], i);
            }
        }
    }

    function addEmployee(address employeeID, uint salary) {
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(employeeID); // employee获取返回的两个值中的第一个值
        assert(employee.id == 0x0); //"The employeeID exists!"
        employees.push(Employee(employeeID, salary, now));
    }

    function removeEmployee(address employeeID) {
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(employeeID); 
        assert(employee.id != 0x0); // "The employeeID not exist!"
        _partialPaid(employee);
        delete employees[index];  // delete以后位置是空白的，不太便于日后操作
        employees[index] = employees[employees.length - 1]; // 一个技巧是将最后一个employee提到被删的那个位置上
        employees.length -= 1; // 然后将数组size缩小
    }

    function updateEmployee(address employeeID, uint salary) {
        require(msg.sender == owner);
        var (employee, index) = _findEmployee(employeeID); 
        assert(employee.id != 0x0);  //  "The employeeID not exist!"
        _partialPaid(employee);
        employees[index].salary = salary; // instead of using memory variable, it should change the storage variable
        employees[index].lastPayday = now;
    }

    function addFund() payable returns(uint){
        return this.balance;
    }

    function calculateRunway() payable returns (uint) {
        uint totalSalary = 0;
        for (uint i = 0; i < employees.length; i++) {
            totalSalary += employees[i].salary;
        }
        return this.balance / totalSalary;
    } 

    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() {
        var (employee, index) = _findEmployee(msg.sender); 
        assert(employee.id != 0x0); 
        
        uint nextPayDay = employee.lastPayday + payDuration;
        assert(nextPayDay < now);
        
        employees[index].lastPayday = nextPayDay; // the internal status change must come before external transfer
        employee.id.transfer(employee.salary);
    }
}