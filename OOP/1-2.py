# Python Object-Oriented Programming

# lecture 1

class Employee:

    num_of_emp = 0
    raise_amount = 1.04

    def __init__(self, first, last, pay):
        self.first = first
        self.last = last
        self.pay = pay
        self.email = first + '.' + last + '@company.com'

        Employee.num_of_emp += 1

    def fullname(self):
        # '{} {}' gives us full name
        return '{} {}'.format(self.first, self.last)

    def apply_raise(self):  # Employee.raise_amount (works the same way as self)
        self.pay = int(self.pay * self.raise_amount)


print(Employee.num_of_emp)

emp_1 = Employee('Corey', 'Schafer', 50000)
emp_2 = Employee('Test', 'User', 60000)

# two ways of getting employee's fullname
# in this case there is no need in putting something in brackets because we call object
print(emp_1.fullname())
# here we start from calling class so it's necessary to specify the object we are calling
print(Employee.fullname(emp_1))

# lecture 2

# print(emp_1.raise_amount)
# print(emp_2.raise_amount)
# # raising employees' salaries on 4%
# emp_1.apply_raise()
# print(Employee.raise_amount)

# emp_1.raise_amount()
# Employee.raise_amount()

# # dict shows all elements of class Employee
# print(Employee.__dict__)

# Employee.raise_amount = 1.05

# print(Employee.raise_amount)
# print(emp_1.raise_amount)
# print(emp_2.raise_amount)

emp_1.raise_amount = 1.05

print(emp_1.__dict__)

print(Employee.num_of_emp)

# lecture 3: class methods and static methods
