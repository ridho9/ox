include Nice_parser.Make (struct
  type result = Ast.stmt list
  type token = Parser.token

  exception ParseError = Parser.Error

  let parse = Parser.prog

  (* exception LexError = Lexer.LexError *)

  let next_token = Lexer.read

  include Lexer
end)