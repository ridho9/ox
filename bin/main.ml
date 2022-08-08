open Base
open Lexing
open Ox

let argv = Sys.get_argv ()

let parsefunc () =
  if Array.length argv = 2 then
    Parse.parse_file argv.(1)
  else
    let lb = Lexing.from_channel Stdio.stdin in
    Lexing.set_filename lb "stdin";
    Parse.parse_chan ~pos:lb.lex_curr_p Stdio.stdin

let () =
  Parse.pp_exceptions ();
  let res = parsefunc () in
  let env = Env.create () in
  Intp.run env res
