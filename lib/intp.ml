open Ast
open Value
open Builtins

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

let run expr =
  let result = eval () expr in
  print_endline (show result)