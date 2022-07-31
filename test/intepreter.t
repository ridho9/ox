Test expression
  $ ox << EOF
  > print 5;
  > print 1+10;
  > print 2*5;
  > print true;
  > print false;
  > print nil;
  > print 10/2;
  > print 10-20;
  > print 10 < 20;
  > print 20 > 10;
  > print 10 <= 10;
  > print 10 >= 10;
  > print 1 + 2*3;
  > EOF
  5
  11
  10
  true
  false
  nil
  5
  -10
  true
  true
  true
  true
  7

Runtime error
  $ ox << EOF
  > print 1 + true;
  > EOF
  RuntimeError: expected integer, found true
  Stacktrace: 
    stdin - 1:9
    stdin - 1:1
  [1]

  $ ox << EOF
  > print 1 / 0;
  > EOF
  RuntimeError: divide by zero
  Stacktrace: 
    stdin - 1:9
    stdin - 1:1
  [1]

Variable declaration
  $ ox << EOF
  > var number = 10;
  > print number * 2;
  > EOF
  20

  $ ox << EOF
  > print number * 2;
  > EOF
  RuntimeError: undefined identifier 'number'
  Stacktrace: 
    stdin - 1:7
    stdin - 1:1
  [1]

  $ ox << EOF
  > var number = 10;
  > print number;
  > number = number * 2;
  > print number;
  > EOF
  10
  20

Block Expression
  $ ox << EOF 
  > print {
  >   var a = 10;
  >   a * 2
  > };
  > EOF
  20

  $ ox << EOF 
  > var a = 5;
  > print {
  >   var a = 10;
  >   a * 2
  > };
  > print a;
  > EOF
  20
  5

  $ ox << EOF 
  > var a = 10;
  > print {
  >   var b = 2;
  >   a * b
  > };
  > EOF
  20

  $ ox << EOF 
  > print {
  >   var b = 2;
  >   a * b
  > };
  > print -1;
  > EOF
  RuntimeError: undefined identifier 'a'
  Stacktrace: 
    stdin - 3:3
    stdin - 1:1
  [1]
