open Printf




let (!!) = Obj.magic

type 'a logic = Var of 'a var_desc | Value of 'a * ('a -> string)
and 'a var_desc =
  { index: int
  ; mutable reifier: unit -> 'a logic * 'a logic list
  }

let var_of_int index =
  let rec ans = Var { index; reifier=fun () -> (ans,[]) } in
  ans

let const_not_implemented _ =   "<not implemented>"
let (!) x = Value (x, const_not_implemented)
let embed {S : ImplicitPrinters.SHOW} x = Value (x, S.show)

let embed_explicit printer x = Value (x, printer)

module Show_logic_explicit (X : ImplicitPrinters.SHOW) = struct
    type t = X.t logic
    let show l =
      match l with
      | Var {index; _} -> sprintf "_.%d" index
      | Value (x,_) -> X.show x
end

implicit module Show_logic {X : ImplicitPrinters.SHOW} = struct
    type t = X.t logic
    let show l =
      match l with
      | Var {index; _} -> sprintf "_.%d" index
      | Value (x,_) -> X.show x
end

let show_logic_naive =
  function
  | Var {index;_} -> sprintf "_.%d" index
  | Value (x,printer) ->
    (* TODO: add assert that printer is a function *)
    (* but fix js_of_ocaml before doing that *)
    printer x

type 'a llist = Nil | Cons of 'a logic * 'a llist logic

let const_empty_list_str _ = "[]"
let llist_nil = Value(Nil, const_empty_list_str)

let llist_printer v =
  let b = Buffer.create 49 in
  let rec helper = function
    | Cons (h,tl) -> begin
        Buffer.add_string b (show_logic_naive h);
        Buffer.add_string b " :: ";
        match tl with
        | Var n -> Buffer.add_string b (show_logic_naive tl)
        | Value (v,pr) -> Buffer.add_string b (pr v)
      end
    | Nil -> Buffer.add_string b "[]"
  in
  helper v;
  Buffer.contents b

module Show_llist_explicit (X: ImplicitPrinters.SHOW) = struct
  type t = X.t llist
  let show = llist_printer
end

implicit module Show_llist {X: ImplicitPrinters.SHOW} = struct
  type t = X.t llist
  let show = llist_printer
end

let () =
  let open ImplicitPrinters in
  let (_) = embed (Nil: int llist) in
  let () = print_endline @@ show (Nil: string   llist) in
  let (_: string) = show (embed ("asdf": string)) in
  ()
