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
  | Id id -> get_id expr.pos_e env id
  | Unary (op, e) -> (
      let e' = eval env e in
      match op with
      | Minus -> unary_minus expr.pos_e e'
      | Bang -> unary_bang expr.pos_e e')
  | Binop (op, e1, e2) ->
      let v1 = eval env e1 in
      let v2 = eval env e2 in
      binary_op expr.pos_e op v1 v2
  | Block (stmts, e) -> (
      let new_env = Env.extend env in
      run_stmts new_env stmts;
      match e with None -> Nil | Some e -> eval new_env e)
  | If (e, v1, v2) -> (
      let e' = eval env e in
      if is_truthy e' then
        eval env v1
      else
        match v2 with None -> Nil | Some e2 -> eval env e2)

and eval_stmt env stmt =
  try
    match stmt.stmt with
    | Print e ->
        let e' = eval env e in
        print_endline (Value.show e')
    | Expr e ->
        let _ = eval env e in
        ()
    | Decl (name, e) ->
        let v = match e with None -> Nil | Some expr -> eval env expr in
        Env.put env name v
    | Assign (name, expr) ->
        get_id stmt.pos_s env name |> ignore;
        let v = eval env expr in
        Env.replace env name v
  with RuntimeError (msg, pos) ->
    RuntimeError (msg, stmt.pos_s :: pos) |> raise

and run_stmts env = function
  | [] -> ()
  | stmt :: res ->
      eval_stmt env stmt;
      run_stmts env res

let run_stmt env stmt =
  try Ok (eval_stmt env stmt)
  with exn -> (
    match exn with
    | RuntimeError (msg, pos) ->
        printf "RuntimeError: %s\n" msg;
        printf "Stacktrace: \n";
        let rec print_stack = function
          | [] -> ()
          | hd :: tl ->
              let s = str_pos hd in
              printf "  %s\n" s;
              print_stack tl
        in
        print_stack (List.rev pos);
        Error exn
    | exn -> raise exn)

let rec run env = function
  | [] -> ()
  | stmt :: rest -> (
      match run_stmt env stmt with Ok _ -> run env rest | Error _ -> exit 1)
