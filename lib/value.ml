type t = Int of int | Bool of bool | Nil

let type_is t = match t with Int _ -> `Int | Bool _ -> `Bool | Nil -> `Nil

let type_name t =
  match type_is t with `Int -> "integer" | `Bool -> "boolean" | `Nil -> "nil"

let show t =
  match t with
  | Nil -> "nil"
  | Bool b -> if b then "true" else "false"
  | Int i -> Printf.sprintf "%d" i
