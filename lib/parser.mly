%{
  open Ast
%}

%token <int> INT
%token TRUE
%token FALSE
%token NIL

%token LPAREN
%token RPAREN
%token MINUS
%token BANG
%token STAR
%token FSLASH
%token PLUS
%token GT GTEQ LT LTEQ
%token EQEQ BANG_EQ

%token EOF

%left EQEQ BANG_EQ
%left GT GTEQ LT LTEQ
%left PLUS MINUS
%left STAR FSLASH
%nonassoc BANG

%start <expr list> prog
%%

prog:
  | e = expr+; EOF { e }
  ;

expr:
  | i = INT { Int i } 
  | TRUE { Bool true }
  | FALSE { Bool false }
  | NIL { Nil }
  | LPAREN; e = expr; RPAREN { e }
  | o = unop; e = expr { Unary (o, e) }
  | e1 = expr; op = binop; e2 = expr { Binop (op, e1, e2) }
  ;

%inline unop:
  | BANG { Bang }
  ;

%inline binop:
  | STAR { Multiply }
  | FSLASH { Divide }
  | PLUS { Plus }
  | MINUS { Subtract }
  | GT { Greater }
  | GTEQ { GreaterEq }
  | LT { Less }
  | LTEQ { LessEq }
  | EQEQ { EqEq }
  | BANG_EQ { BangEq }
  ;