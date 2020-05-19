type t = string;
type view =
  | Loading
  | HasValue
  | HasError;

[@bs.inline]
let loading = "loading";
[@bs.inline]
let hasValue = "hasValue";
[@bs.inline]
let hasError = "hasError";

let view =
  fun
  | "loading" => Loading
  | "hasValue" => HasValue
  | "hasError" => HasError
  | other => failwith("unrecognized State value: " ++ other);