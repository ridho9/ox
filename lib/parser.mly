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

%token PRINT
%token SEMICOLON

%token EOF

%left EQEQ BANG_EQ
%left GT GTEQ LT LTEQ
%left PLUS MINUS
%left STAR FSLASH

%start <Ast.stmt list> prog
%%

prog:
  | s = stmt*; EOF { s }
  ;

stmt:
  | PRINT; e = expr; SEMICOLON { Print e |> stmt_pos $startpos }
  | e = expr; SEMICOLON { Expr e |> stmt_pos $startpos }
  ;

expr:
  | e = unary { e }
  | e1 = expr; op = binop; e2 = expr { Binop (op, e1, e2) |> expr_pos $startpos(op) }
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
  | op = unop; e = unary { Unary (op, e) |> expr_pos $startpos(op) }
  | e = primary { e }
  ;

%inline unop:
  | BANG { Bang }
  | MINUS { Minus }
  ;

primary:
  | i = INT { Int i |> expr_pos $startpos } 
  | TRUE { Bool true |> expr_pos $startpos }
  | FALSE { Bool false |> expr_pos $startpos }
  | NIL { Nil |> expr_pos $startpos }
  | LPAREN; e = expr; RPAREN { e }
  ;


