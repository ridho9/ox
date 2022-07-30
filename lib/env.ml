type table = (string, Value.t) Hashtbl.t

let pp_table formatter (tbl : table) =
  let seq = Hashtbl.to_seq tbl in
  let seq =
    Seq.fold_left
      (fun acc (k, v) -> Printf.sprintf "%s%s=%s; " acc k (Value.show v))
      "" seq
  in
  Format.pp_print_string formatter seq

type t = { tbl : table } [@@deriving show]

let create () = { tbl = Hashtbl.create 64 }
let put env name value = Hashtbl.replace env.tbl name value
let get env name = Hashtbl.find env.tbl name