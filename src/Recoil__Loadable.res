module State = {
  type t = string
  @inline
  let loading = "loading"
  @inline
  let hasValue = "hasValue"
  @inline
  let hasError = "hasError"
}

type t<'a>

@get external state: t<'value> => State.t = "state"

@send external getValue: t<'value> => 'value = "getValue"
@send
external toPromise: t<'value> => Js.Promise.t<'value> = "toPromise"

@send @return(undefined_to_opt)
external valueMaybe: t<'value> => option<'value> = "valueMaybe"
@send external valueOrThrow: t<'value> => 'value = "valueOrThrow"

@send external errorMaybe: t<'value> => option<'error> = "errorMaybe"
@send external errorOrThrow: t<'value> => 'error = "errorOrThrow"

@send @return(undefined_to_opt)
external promiseMaybe: t<'value> => option<Js.Promise.t<'value>> = "promiseMaybe"
@send
external promiseOrThrow: t<'value> => Js.Promise.t<'value> = "promiseOrThrow"

@send external map: (t<'value>, 'value => 'b) => t<'b> = "map"
@send
external mapAsync: (t<'value>, 'value => Js.Promise.t<'b>) => t<'b> = "map"
