%{
  open Ast
%}

%token <int> INT
%token <string> ID
%token TRUE
%token FALSE
%token NIL

%token LPAREN
%token RPAREN
%token LCURLY
%token RCURLY
%token MINUS
%token BANG
%token STAR
%token FSLASH
%token PLUS
%token GT GTEQ LT LTEQ
%token EQEQ BANG_EQ
%token AND OR

%token PRINT
%token SEMICOLON
%token VAR
%token EQ
%token IF
%token ELSE

%token EOF

%left AND OR
%left EQEQ BANG_EQ
%left GT GTEQ LT LTEQ
%left PLUS MINUS
%left STAR FSLASH

%start <Ast.stmt list> prog
%%

prog:
  | s = decl_list; EOF { s }
  ;

%inline decl_list:
  | (* empty *) { [] }
  | s = rev_decl_list { List.rev s }

rev_decl_list:
  | s = decl { [s] }
  | left = rev_decl_list; s = decl { s :: left }
  ;

decl:
  | s = var_decl { s }
  | s = stmt { s }
  ;

var_decl:
  | VAR; name = ID; EQ; value = expr; SEMICOLON { Decl (name, (Some value)) |> stmt_pos $startpos }
  | VAR; name = ID; SEMICOLON { Decl (name, None) |> stmt_pos $startpos }
  ;

stmt:
  | PRINT; e = expr; SEMICOLON { Print e |> stmt_pos $startpos }
  | e = expr; SEMICOLON { Expr e |> stmt_pos $startpos }
  | n = ID; EQ; value = expr; SEMICOLON { Assign(n, value) |> stmt_pos $startpos }
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
  | AND { And }
  | OR { Or }
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
  | b = block_expr { b }
  | i = if_expr { i }
  | i = INT { Int i |> expr_pos $startpos } 
  | i = ID { Id i |> expr_pos $startpos } 
  | TRUE { Bool true |> expr_pos $startpos }
  | FALSE { Bool false |> expr_pos $startpos }
  | NIL { Nil |> expr_pos $startpos }
  | LPAREN; e = expr; RPAREN { e }
  ;

if_expr:
  | IF; e = expr; b1 = block_expr { If(e, b1, None) |> expr_pos $startpos }
  | IF; e = expr; b1 = block_expr; ELSE; b2 = block_expr { If(e, b1, Some b2) |> expr_pos $startpos }
  | IF; e = expr; b1 = block_expr; ELSE; elif = if_expr { If(e, b1, Some elif) |> expr_pos $startpos }
  ;

block_expr:
  | LCURLY; s = decl_list; e = expr?; RCURLY { Block(s, e) |> expr_pos $startpos }
  ;

%%