open Core
open Lexing
open Ox

let argv = Sys.get_argv ()
let fname = if Array.length argv = 2 then argv.(1) else "stdin"

let ic =
  if Array.length argv = 2 then
    In_channel.create argv.(1)
  else
    In_channel.stdin

let print_error_position lexbuf =
  let pos = lexbuf.lex_curr_p in
  sprintf "%s:[%d:%d]" pos.pos_fname pos.pos_lnum
    (pos.pos_cnum - pos.pos_bol + 1)

let parse_program lexbuf =
  try Ok (Parser.prog Lexer.read lexbuf) with
  (* catch exception and turn into Error *)
  | Parser.Error ->
      let error_msg =
        sprintf "%s: syntax error." (print_error_position lexbuf)
      in
      Error (Error.of_string error_msg)
  | Failure s ->
      let error_msg =
        sprintf "%s: error: %s." (print_error_position lexbuf) s
      in
      Error (Error.of_string error_msg)

let () =
  let lexbuf = Lexing.from_channel ic in
  lexbuf.lex_curr_p <- { lexbuf.lex_curr_p with pos_fname = fname };
  let result = parse_program lexbuf in
  match result with
  | Ok res -> List.iter res ~f:(fun r -> Ast.show_expr r |> print_endline)
  | Error err -> err |> Error.to_string_hum |> print_endline