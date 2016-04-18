
(** Type of typed logic variable *)
type 'a logic = private Var of 'a var_desc | Value of 'a * ('a -> string)
and  'a var_desc =
  { index: int
  ; mutable reifier: unit -> 'a logic * ('a logic list)
  }


(** Lifting primitive *)
val (!) : 'a -> 'a logic

val embed : {S: ImplicitPrinters.SHOW} -> S.t -> S.t logic
val embed_explicit: ('a -> string) -> 'a -> 'a logic

module Show_logic_explicit : functor (X : ImplicitPrinters.SHOW) -> sig
                        type t = X.t logic
                        val show : X.t logic -> string
end

module Show_logic : functor {X : ImplicitPrinters.SHOW} -> sig
                        type t = X.t logic
                        val show : X.t logic -> string
end

val show_logic_naive : 'a logic -> string

(** Type of ligic lists *)
type 'a llist = Nil | Cons of 'a logic * 'a llist logic

module Show_llist_explicit : functor (X : ImplicitPrinters.SHOW) -> sig
                       type t = X.t llist
                       val show : X.t llist -> string
end

module Show_llist : functor {X : ImplicitPrinters.SHOW} -> sig
                       type t = X.t llist
                       val show : X.t llist -> string
end
