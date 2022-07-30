open Ast
open Value

type value = Value.t

exception RuntimeError of string * position option

let assert_int ?pos value =
  match value with
  | Int i -> i
  | _ ->
      let msg = Printf.sprintf "expected integer, found %s" (show value) in
      RuntimeError (msg, pos) |> raise

let assert_bool ?pos value =
  match value with
  | Bool i -> i
  | _ ->
      let msg = Printf.sprintf "expected boolean, found %s" (show value) in
      RuntimeError (msg, pos) |> raise

let unary_minus ?pos value =
  let i = assert_int ?pos value in
  Int (-i)

let unary_bang ?pos value =
  let b = assert_bool ?pos value in
  Bool (not b)

let binop_gen ?pos a1 a2 opfunc v1 v2 =
  let w1 = a1 ?pos v1 in
  let w2 = a2 ?pos v2 in
  opfunc w1 w2

let binary_op ?pos op v1 v2 =
  let binop_int_int = binop_gen ?pos assert_int assert_int in
  let binop_func =
    match op with
    | Plus -> binop_int_int (fun x y -> Int (x + y))
    | Subtract -> binop_int_int (fun x y -> Int (x - y))
    | Multiply -> binop_int_int (fun x y -> Int (x * y))
    | Divide -> binop_int_int (fun x y -> Int (x / y))
    | Greater -> binop_int_int (fun x y -> Bool (x > y))
    | GreaterEq -> binop_int_int (fun x y -> Bool (x >= y))
    | Less -> binop_int_int (fun x y -> Bool (x < y))
    | LessEq -> binop_int_int (fun x y -> Bool (x <= y))
    | EqEq -> fun x y -> Bool (x = y)
    | BangEq -> fun x y -> Bool (x != y)
  in
  binop_func v1 v2