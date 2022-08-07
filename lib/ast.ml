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
  | Block of stmt list * expr option
  | If of expr * expr * expr option

and expr = { expr : expr_t; pos_e : position }

and stmt_t =
  | Expr of expr
  | Print of expr
  | Decl of string * expr option
  | Assign of string * expr

and stmt = { stmt : stmt_t; pos_s : position } [@@deriving show]

let expr_pos pos_e expr = { expr; pos_e }
let stmt_pos pos_s stmt = { stmt; pos_s }
