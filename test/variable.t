Variable declaration
  $ ox << EOF
  > var number = 10;
  > print number * 2;
  > EOF
  20

  $ ox << EOF
  > var number = 10;
  > print number;
  > var number = 20;
  > print number;
  > EOF
  10
  20

  $ ox << EOF
  > print number * 2;
  > EOF
  RuntimeError: undefined identifier 'number'
  Stacktrace: 
    stdin - 1:7
    stdin - 1:1
  [1]

Variable Assignment
  $ ox << EOF
  > var number = 10;
  > print number;
  > number = number * 2;
  > print number;
  > EOF
  10
  20

  $ ox << EOF
  > var number = 10;
  > print number;
  > missing = number * 2;
  > print number;
  > EOF
  10
  RuntimeError: undefined identifier 'missing'
  Stacktrace: 
    stdin - 3:1
    stdin - 3:1
  [1]

Replacing outer scope variable
  $ ox << EOF
  > var number = 10;
  > print number;
  > {
  >   number = number * 2;
  >   print number;
  > };
  > print number;
  > {
  >   var number = 50;
  >   number = number * 2;
  >   print number;
  > };
  > print number;
  > EOF
  10
  20
  20
  100
  20
