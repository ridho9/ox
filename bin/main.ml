open Core
open Lexing
open Ox

let argv = Sys.get_argv ()

let ic, fname =
  if Array.length argv = 2 then
    let fn = argv.(1) in
    (In_channel.create fn, fn)
  else
    (In_channel.stdin, "stdin")

let print_error_position lexbuf =
  let pos = lexbuf.lex_curr_p in
  Ast.str_pos pos

let parse_program lexbuf =
  try Ok (Parser.prog Lexer.read lexbuf) with
  (* catch exception and turn into Error *)
  | Parser.Error ->
      let error_msg =
        sprintf "%s: syntax error." (print_error_position lexbuf)
      in
      Error (Error.of_string error_msg)
  | Failure s | Lexer.SyntaxError s ->
      let error_msg =
        sprintf "%s: error: %s." (print_error_position lexbuf) s
      in
      Error (Error.of_string error_msg)

(* let handle_parsed ast = ast |> Ast.show_expr |> print_endline *)

let () =
  let lexbuf = Lexing.from_channel ic in
  lexbuf.lex_curr_p <- { lexbuf.lex_curr_p with pos_fname = fname };
  let result = parse_program lexbuf in
  match result with
  | Ok res ->
      let env = Env.create () in
      Intp.run env res
  | Error err -> err |> Error.to_string_hum |> Out_channel.prerr_endline
