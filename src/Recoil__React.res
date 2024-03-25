module RecoilRoot = {
  type initializeStateParams = {set: 'value 'mode. (Recoil__Value.t<'value, 'mode>, 'value) => unit}
  type initializeState = initializeStateParams => unit

  @react.component @module("recoil")
  external make: (~initializeState: initializeState=?, ~children: React.element) => React.element =
    "RecoilRoot"
}

@module("recoil")
external useRecoilState: Recoil__Value.readWrite<'value> => ('value, ('value => 'value) => unit) =
  "useRecoilState"

@module("recoil")
external useRecoilValue: Recoil__Value.t<'value, 'mode> => 'value = "useRecoilValue"

type set<'a> = ('a => 'a) => unit

@module("recoil")
external useSetRecoilState: Recoil__Value.readWrite<'value> => set<'value> = "useSetRecoilState"

type reset = unit => unit

@module("recoil")
external useResetRecoilState: Recoil__Value.readWrite<'value> => reset = "useResetRecoilState"

@module("recoil")
external useRecoilValueLoadable: Recoil__Value.t<'value, 'mode> => Recoil__Loadable.t<'value> =
  "useRecoilValueLoadable"

type mutableSnapshot = {
  set: 'value 'mode. (Recoil__Value.t<'value, 'mode>, 'value => 'value) => unit,
  reset: 'value 'mode. Recoil__Value.t<'value, 'mode> => unit,
}

type rec snapshot = {
  getPromise: 'value 'mode. Recoil__Value.t<'value, 'mode> => promise<'value>,
  getLoadable: 'value 'mode. Recoil__Value.t<'value, 'mode> => Recoil__Loadable.t<'value>,
  map: (mutableSnapshot => unit) => snapshot,
  asyncMap: (mutableSnapshot => promise<unit>) => promise<snapshot>,
}

type callbackParam = {
  snapshot: snapshot,
  gotoSnapshot: snapshot => unit,
  set: 'value. (Recoil__Value.readWrite<'value>, 'value => 'value) => unit,
  reset: 'value. Recoil__Value.readWrite<'value> => unit,
}

type callback<'additionalArg, 'returnValue> = 'additionalArg => 'returnValue

@module("recoil")
external useRecoilCallback: (
  @uncurry callbackParam => callback<'additionalArg, 'returnValue>
) => callback<'additionalArg, 'returnValue> = "useRecoilCallback"

@module("recoil")
external useRecoilCallback0: (
  @uncurry callbackParam => callback<'additionalArg, 'returnValue>,
  @as(json`[]`) _,
) => callback<'additionalArg, 'returnValue> = "useRecoilCallback"

@module("recoil")
external useRecoilCallback1: (
  @uncurry callbackParam => callback<'additionalArg, 'returnValue>,
  array<'a>,
) => callback<'additionalArg, 'returnValue> = "useRecoilCallback"

@module("recoil")
external useRecoilCallback2: (
  @uncurry callbackParam => callback<'additionalArg, 'returnValue>,
  ('a, 'b),
) => callback<'additionalArg, 'returnValue> = "useRecoilCallback"

@module("recoil")
external useRecoilCallback3: (
  @uncurry callbackParam => callback<'additionalArg, 'returnValue>,
  ('a, 'b, 'c),
) => callback<'additionalArg, 'returnValue> = "useRecoilCallback"

@module("recoil")
external useRecoilCallback4: (
  @uncurry callbackParam => callback<'additionalArg, 'returnValue>,
  ('a, 'b, 'c, 'd),
) => callback<'additionalArg, 'returnValue> = "useRecoilCallback"

@module("recoil")
external useRecoilCallback5: (
  @uncurry callbackParam => callback<'additionalArg, 'returnValue>,
  ('a, 'b, 'c, 'd, 'e),
) => callback<'additionalArg, 'returnValue> = "useRecoilCallback"

module Uncurried = {
  type uncurriedCallback<'additionalArg, 'returnValue> = 'additionalArg => 'returnValue

  @module("recoil")
  external useRecoilCallback: (
    @uncurry callbackParam => callback<'additionalArg, 'returnValue>
  ) => uncurriedCallback<'additionalArg, 'returnValue> = "useRecoilCallback"

  @module("recoil")
  external useRecoilCallback0: (
    @uncurry callbackParam => callback<'additionalArg, 'returnValue>,
    @as(json`[]`) _,
  ) => uncurriedCallback<'additionalArg, 'returnValue> = "useRecoilCallback"

  @module("recoil")
  external useRecoilCallback1: (
    @uncurry callbackParam => callback<'additionalArg, 'returnValue>,
    array<'a>,
  ) => uncurriedCallback<'additionalArg, 'returnValue> = "useRecoilCallback"

  @module("recoil")
  external useRecoilCallback2: (
    @uncurry callbackParam => callback<'additionalArg, 'returnValue>,
    ('a, 'b),
  ) => uncurriedCallback<'additionalArg, 'returnValue> = "useRecoilCallback"

  @module("recoil")
  external useRecoilCallback3: (
    @uncurry callbackParam => callback<'additionalArg, 'returnValue>,
    ('a, 'b, 'c),
  ) => uncurriedCallback<'additionalArg, 'returnValue> = "useRecoilCallback"

  @module("recoil")
  external useRecoilCallback4: (
    @uncurry callbackParam => callback<'additionalArg, 'returnValue>,
    ('a, 'b, 'c, 'd),
  ) => uncurriedCallback<'additionalArg, 'returnValue> = "useRecoilCallback"

  @module("recoil")
  external useRecoilCallback5: (
    @uncurry callbackParam => callback<'additionalArg, 'returnValue>,
    ('a, 'b, 'c, 'd, 'e),
  ) => uncurriedCallback<'additionalArg, 'returnValue> = "useRecoilCallback"
}
