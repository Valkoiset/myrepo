# Python Object-Oriented Programming

# lecture 5: Special (Magic/Dunder) Methods

# /usr/local/bin/python3.6 /Users/valkoiset/Desktop/Python/OOP/5.py

class Employee:

   num_of_emp = 0
   raise_amt = 1.04

   # Double underscore "__" is called "Dunder". So, you can often hear someone says "Dunder init"
   def __init__(self, first, last, pay):
      self.first = first
      self.last = last
      self.pay = pay
      self.email = first + '.' + last + '@company.com'

      Employee.num_of_emp += 1

   def fullname(self):
           # '{} {}' gives full name
      return '{} {}'.format(self.first, self.last)

   def apply_raise(self):  # Employee.raise_amount (works the same way as self)
      self.pay = int(self.pay * self.raise_amt)

   # unambiguous representation of an object and should be used for debugging and logging and things like that
   def __repr__(self):
      return "Employee('{}', '{}', '{}')".format(self.first, self.last, self.pay)

   # more readable representation of an object and is meant to be used as a display to the user
   def __str__(self):
      return '{} - {}'.format(self.fullname(), self.email)

   def __add__(self, other):
      return self.pay + other.pay

   def __len__(self):
      return len(self.fullname())


emp_1 = Employee('Corey', 'Schafer', 50000)
emp_2 = Employee('Test', 'User', 60000)

# both lines do the same
# print(len('test'))
# print('test'.__len__())

print(len(emp_1))

print(emp_1 + emp_2)

print(emp_1)

print(repr(emp_1))
print(str(emp_1))

# this is the same as previous example. We just calling the function in a different way
print(emp_1.__repr__())
print(emp_1.__str__())

print(1 + 2)
print(int.__add__(1, 2))
print(str.__add__("a", "b"))
