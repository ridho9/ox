type position = Lexing.position

let str_pos pos =
  let open Lexing in
  Printf.sprintf "%s - %d:%d" pos.pos_fname pos.pos_lnum
    (pos.pos_cnum - pos.pos_bol + 1)

let pp_position formatter (pos : position) =
  str_pos pos |> Format.pp_print_string formatter;
  ()

type binop =
  | Multiply
  | Divide
  | Plus
  | Subtract
  | Greater
  | GreaterEq
  | Less
  | LessEq
  | EqEq
  | BangEq
[@@deriving show]

type unop = Bang | Minus [@@deriving show]

type expr_t =
  | Int of int
  | Bool of bool
  | Id of string
  | Nil
  | Unary of unop * expr
  | Binop of binop * expr * expr

and expr = { expr : expr_t; pos : position } [@@deriving show]

let expr_pos pos expr = { expr; pos }

type stmt_t = Expr of expr | Print of expr | Decl of string * expr option
and stmt = { stmt : stmt_t; pos : position } [@@deriving show]

let stmt_pos pos stmt = { stmt; pos }
