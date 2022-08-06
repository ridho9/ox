type table = (string, Value.t) Hashtbl.t

let pp_table formatter (tbl : table) =
  let seq = Hashtbl.to_seq tbl in
  let seq =
    Seq.fold_left
      (fun acc (k, v) -> Printf.sprintf "%s%s=%s; " acc k (Value.show v))
      "" seq
  in
  Format.pp_print_string formatter seq

type t = { parent : t option; tbl : table } [@@deriving show]

let create () = { parent = None; tbl = Hashtbl.create 64 }
let put env name value = Hashtbl.replace env.tbl name value

let rec replace env name value =
  try
    Hashtbl.find env.tbl name |> ignore;
    Hashtbl.replace env.tbl name value
  with Not_found -> (
    match env.parent with
    | None -> raise Not_found
    | Some parent -> replace parent name value)

let rec get env name =
  try Hashtbl.find env.tbl name
  with Not_found -> (
    match env.parent with
    | None -> raise Not_found
    | Some parent -> get parent name)

let extend env = { parent = Some env; tbl = Hashtbl.create 64 }
