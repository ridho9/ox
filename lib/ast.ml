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

type unop = Bang [@@deriving show]

type expr =
  | Int of int
  | Bool of bool
  | Nil
  | Unary of unop * expr
  | Binop of binop * expr * expr
[@@deriving show]
