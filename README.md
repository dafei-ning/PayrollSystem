# Payroll

### Order of Functions

- constructor
- fallback function (if exists)
- external
- public
- internal
- private

严格标注函数可见性 explicitly label the visibility of all functions, including constructors.


状态变量定义为public 有特殊意义，可以直接作为合约创建

external用来修饰function的话，不能被本合约调用，但是可以用this来调用，相当于外部调用