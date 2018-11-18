pragma solidity ^0.4.25;

contract Payroll {

    struct Employee {
        address id;
        uint    salary;
        uint    lastPayday;
    }

    address          owner;
    uint    constant payDuration  = 30 days;
    mapping(address => Employee) employees;




    function Payroll() public {
        owner = msg.sender;
    }

    function _partialPaid(Employee employee) private {
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.id.transfer(payment);
    }

    // function _findEmployee(address employeeID) private returns (Employee, uint) {
    //     for (uint i = 0; i < employees.length; i++) {
    //         if (employees[i].id == employeeID) {
    //             return (employees[i], i);
    //         }
    //     }
    // }

    function addEmployee(address employeeID, uint salary) public {
        require(msg.sender == owner);
        var employee = employees[employeeID]; // employee获取返回的两个值中的第一个值
        assert(employee.id == 0x0); //"The employeeID exists!"
        employees[employeeID] = Employee(employeeID, salary, now);
    }

    function removeEmployee(address employeeID) public {
        require(msg.sender == owner);
        var employee = employees[employeeID]; 
        assert(employee.id != 0x0); // "The employeeID not exist!"
        _partialPaid(employee);
        delete employees[employeeID];  // entry其实是置换成了初始值
    }

    function updateEmployee(address employeeID, uint salary) public {
        require(msg.sender == owner);
        var employee = employees[employeeID]; 
        assert(employee.id != 0x0);  //  "The employeeID not exist!"
        _partialPaid(employee);
        employees[employeeID].salary = salary; // instead of using memory variable, it should change the storage variable
        employees[employeeID].lastPayday = now;
    }

    function addFund() public payable returns(uint){
        return this.balance;
    }

    function calculateRunway() public returns (uint) {
        uint totalSalary = 0;
        
        return this.balance / totalSalary;
    } 

    function hasEnoughFund() public returns (bool) {
        return calculateRunway() > 0;
    }

    function getPaid() public {
        var employee = employees[msg.sender]; 
        assert(employee.id != 0x0); 
        
        uint nextPayDay = employee.lastPayday + payDuration;
        assert(nextPayDay < now);
        
        employees[msg.sender].lastPayday = nextPayDay; // 这种引用是storage里的，可以对状态变量进行修改
        employee.id.transfer(employee.salary);
    }
}