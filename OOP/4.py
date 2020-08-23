# Python Object-Oriented Programming

# lecture 4: Creating Subclasses


class Employee:

   num_of_emp = 0
   raise_amt = 1.04

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
      self.pay = int(self.pay * self.raise_amt)


class Developer(Employee):
   raise_amt = 1.10

   def __init__(self, first, last, pay, prog_lang):
      # super().__init__(first, last, pay)
      # this is also possible instead of super but super better (for me super doesn't work here)
      Employee.__init__(self, first, last, pay)
      self.prog_lang = prog_lang


class Manager(Employee):

   def __init__(self, first, last, pay, employees=None):
      # super().__init__(first, last, pay)
      Employee.__init__(self, first, last, pay)
      if employees is None:
         self.employees = []
      else:
         self.employees = employees

   def add_emp(self, emp):
      if emp not in self.employees:
         self.employees.append(emp)

   def remove_emp(self, emp):
      if emp in self.employees:
         self.employees.remove(emp)

   def print_emps(self):
      for emp in self.employees:
         print('-->', emp.fullname())


dev_1 = Developer('Corey', 'Schafer', 50000, 'Python')
dev_2 = Developer('Test', 'User', 60000, 'Java')

mgr_1 = Manager('Sue', 'Smith', 90000, [dev_1])

print(isinstance(mgr_1, Manager))   # mgr_1 is instance of Manager class
# manager is a sublcass of Employee but it's not a sublclass of Developer. They both are subclasses of Employee
print(issubclass(Manager, Employee))
print(issubclass(Manager, Developer))

# print(mgr_1.email)

# mgr_1.add_emp(dev_2)
# mgr_1.remove_emp(dev_1)

# mgr_1.print_emps()

# print(dev_1.email)
# print(dev_1.prog_lang)

# print(help(Developer))

# print(dev_1.pay)
# dev_1.apply_raise()
# print(dev_1.pay)
