(** Collection of scripts. *)
open Core.Std
open Async.Std

type script = [
| `OCaml of Oloop.Script.t
| `OCaml_toplevel of Oloop.Script.Evaluated.t
| `OCaml_rawtoplevel of Oloop.Script.t
| `Other of string
]

(** One part of a script. *)
type script_part = [
| `OCaml of string
| `OCaml_toplevel of Oloop.Script.Evaluated.phrase list
| `OCaml_rawtoplevel of string
| `Other of string
]

type t = script String.Map.t (** key is filename *)

val eval_script
  :  Rwo_lang.t
  -> filename:string
  -> script Or_error.t Deferred.t

val add_script
  :  t
  -> Rwo_lang.t
  -> filename:(string * string)
  -> t Or_error.t Deferred.t
(** [add_script t (dir,file)] adds the script at path [dir/file] to
    [t]. Only [file] is used as the key in the returned map. *)

val of_html : filename:string -> Rwo_html.t -> t Or_error.t Deferred.t
(** Return all scripts found in given HTML. *)


(******************************************************************************)
(** {2 Printers} *)
(******************************************************************************)
(** Returns a list of <pre> elements. *)
val phrases_to_html
  :  ?pygmentize:bool
  -> Oloop.Script.Evaluated.phrase list
  -> Rwo_html.t Deferred.t

(** Returns a single <div> element. If [pygmentize = true], then the
    element has attribute class="highlight". *)
val script_part_to_html
  :  ?pygmentize:bool
  -> script_part
  -> Rwo_html.item Deferred.t


(******************************************************************************)
(** {2 Map-style Operations } *)
(******************************************************************************)
val empty : t
val find : t -> ?part:float -> filename:string -> script_part option
val find_exn : t -> ?part:float -> filename:string -> script_part
val file_is_mem : t -> string -> bool
