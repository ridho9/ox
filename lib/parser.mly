%{
  open Ast
%}

%token <int> INT
%token EOF

%start <expr list> prog
%%

prog:
  | e = expr+; EOF { e }
  ;

expr:
  | i = INT { Int i } 
  ;
