open Ast
open Value
open Builtins
open Printf

type value = Value.t

let rec eval env expr =
  match expr.expr with
  | Nil -> Nil
  | Int i -> Int i
  | Bool b -> Bool b
  | Unary (op, e) -> (
      let e' = eval env e in
      match op with
      | Minus -> unary_minus ~pos:expr.pos e'
      | Bang -> unary_bang ~pos:expr.pos e')
  | Binop (op, e1, e2) ->
      let v1 = eval env e1 in
      let v2 = eval env e2 in
      binary_op ~pos:expr.pos op v1 v2

let eval_stmt env stmt =
  try
    match stmt.stmt with
    | Print e ->
        let e' = eval env e in
        print_endline (show e')
    | Expr e ->
        let _ = eval env e in
        ()
  with RuntimeError (msg, pos) -> RuntimeError (msg, stmt.pos :: pos) |> raise

let empty_env () = ()

let run_stmt stmt =
  try Some (eval_stmt (empty_env ()) stmt)
  with RuntimeError (msg, pos) ->
    printf "RuntimeError: %s\n" msg;
    printf "Stacktrace: \n";
    let rec print_stack = function
      | [] -> ()
      | hd :: tl ->
          let s = str_pos hd in
          printf "  %s\n" s;
          print_stack tl
    in
    print_stack pos;
    None

let rec run = function
  | [] -> ()
  | stmt :: rest -> (
      match run_stmt stmt with Some _ -> run rest | None -> exit 1)
