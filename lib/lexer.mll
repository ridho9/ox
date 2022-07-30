{
  open Parser
  open Lexing

  exception SyntaxError of string
}

let white = [' ' '\t']+
let newline = '\r' | '\n' | "\r\n"
let digit = ['0'-'9']
let int = digit+

let alpha = ['A'-'Z'] | ['a'-'z']
let alphanum = alpha | digit
let ident = alpha alphanum*

rule read =
  parse 
  | white { read lexbuf }
  | newline { new_line lexbuf; read lexbuf }
  | int { INT (int_of_string (Lexing.lexeme lexbuf)) }  
  | "true" { TRUE }
  | "false" { FALSE }
  | "nil" { NIL }
  | "print" { PRINT }
  | "var" { VAR }
  | ident { ID (Lexing.lexeme lexbuf) }
  | ";" { SEMICOLON }
  | "(" { LPAREN }
  | ")" { RPAREN }
  | "-" { MINUS }
  | "!" { BANG }
  | "*" { STAR }
  | "/" { FSLASH }
  | "+" { PLUS }
  | ">" { GT }
  | ">=" { GTEQ }
  | "<" { LT }
  | "<=" { LTEQ }
  | "==" { EQEQ }
  | "!=" { BANG_EQ }
  | "=" { EQ }
  | _ { raise (SyntaxError ("lexing: illegal character: " ^ Lexing.lexeme lexbuf) ) }
  | eof { EOF }