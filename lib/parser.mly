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

%start <Ast.expr> prog
%%

prog:
  | e = expr; EOF { e }
  ;

expr:
  | e = unary { e }
  | e1 = expr; op = binop; e2 = expr { Binop (op, e1, e2) |> wrap_pos $startpos(op) }
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

unary:
  | op = unop; e = unary { Unary (op, e) |> wrap_pos $startpos(op) }
  | e = primary { e }
  ;

%inline unop:
  | BANG { Bang }
  | MINUS { Minus }
  ;

primary:
  | i = INT { Int i |> wrap_pos $startpos } 
  | TRUE { Bool true |> wrap_pos $startpos }
  | FALSE { Bool false |> wrap_pos $startpos }
  | NIL { Nil |> wrap_pos $startpos }
  | LPAREN; e = expr; RPAREN { e }
  ;


