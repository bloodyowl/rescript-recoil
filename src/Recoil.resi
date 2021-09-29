// Value
type readOnlyMode = ReadOnly

type readWriteMode = ReadWrite

// A value can either be in read-only mode or in read/write
type t<'value, 'mode>
// Shorthands
type readOnly<'value> = t<'value, readOnlyMode>
type readWrite<'value> = t<'value, readWriteMode>

// Utility function
@module("recoil") external isRecoilValue: 'any => bool = "isRecoilValue"

// Atom creation
type trigger = [#get | #set]

type atomEffect<'value> = {
  node: readWrite<'value>,
  trigger: trigger,
  setSelf: ('value => 'value) => unit,
  resetSelf: unit => unit,
  onSet: ((~newValue: 'value, ~oldValue: 'value) => unit) => unit,
}

type atomConfig<'value> = {
  key: string,
  default: 'value,
}

type atomWithEffectsConfig<'value> = {
  key: string,
  default: 'value,
  effects_UNSTABLE: array<atomEffect<'value> => option<unit => unit>>,
}

type atomWithDangerouslyAllowMutabilityConfig<'value> = {
  key: string,
  default: 'value,
  dangerouslyAllowMutability: bool,
}

type atomFamilyConfig<'parameter, 'value> = {
  key: string,
  default: 'parameter => 'value,
}

type atomFamilyWithEffectsConfig<'parameter, 'value> = {
  key: string,
  default: 'parameter => 'value,
  effects_UNSTABLE: 'parameter => array<atomEffect<'value> => option<unit => unit>>,
}

type atomFamily<'parameter, 'value> = 'parameter => 'value

@module("recoil")
external atom: atomConfig<'value> => readWrite<'value> = "atom"

@module("recoil")
external atomWithEffects: atomWithEffectsConfig<'value> => readWrite<'value> = "atom"

@module("recoil")
external atomWithDangerouslyAllowMutability: atomWithDangerouslyAllowMutabilityConfig<
  'value,
> => readWrite<'value> = "atom"


@module("recoil")
external asyncAtom: atomConfig<Js.Promise.t<'value>> => readWrite<'value> = "atom"

@module("recoil")
external asyncAtomWithEffects: atomWithEffectsConfig<'value> => readWrite<'value> = "atom"

@module("recoil")
external atomFromRecoilValue: atomConfig<t<'value, _>> => readWrite<'value> = "atom"

@module("recoil")
external atomWithEffectsFromRecoilValue: atomWithEffectsConfig<t<'value, _>> => readWrite<'value> =
  "atom"

@module("recoil")
external atomFamily: atomFamilyConfig<'parameter, 'value> => atomFamily<
  'parameter,
  readWrite<'value>,
> = "atomFamily"

@module("recoil")
external asyncAtomFamily: atomFamilyConfig<'parameter, Js.Promise.t<'value>> => atomFamily<
  'parameter,
  readWrite<'value>,
> = "atomFamily"

@module("recoil")
external atomFamilyFromRecoilValue: atomFamilyConfig<'parameter, t<'value, _>> => atomFamily<
  'parameter,
  readWrite<'value>,
> = "atomFamily"

@module("recoil")
external atomFamilyWithEffects: atomFamilyWithEffectsConfig<'parameter, 'value> => atomFamily<
  'parameter,
  readWrite<'value>,
> = "atomFamily"

@module("recoil")
external asyncAtomFamilyWithEffects: atomFamilyWithEffectsConfig<
  'parameter,
  Js.Promise.t<'value>,
> => atomFamily<'parameter, readWrite<'value>> = "atomFamily"

@module("recoil")
external atomFamilyWithEffectsFromRecoilValue: atomFamilyWithEffectsConfig<
  'parameter,
  t<'value, _>,
> => atomFamily<'parameter, readWrite<'value>> = "atomFamily"

// Selector creation
type getter = {get: 'value 'mode. t<'value, 'mode> => 'value}

type getterAndSetter = {
  get: 'value 'mode. t<'value, 'mode> => 'value,
  set: 'value. (readWrite<'value>, 'value => 'value) => unit,
  reset: 'value. readWrite<'value> => unit,
}

type getValue<'value> = getter => 'value
type setValue<'value> = (getterAndSetter, 'value) => unit

type selectorFamily<'parameter, 'value> = 'parameter => 'value

type selectorConfig<'value> = {
  key: string,
  get: getValue<'value>,
}

type selectorWithWriteConfig<'value> = {
  key: string,
  get: getter => 'value,
  set: setValue<'value>,
}

@unboxed
type fn<'a> = Fn('a)

type asyncSelectorConfig<'value> = {
  key: string,
  get: getValue<Js.Promise.t<'value>>,
}

type selectorConfigFromRecoilValue<'value, 'mode> = {
  key: string,
  get: getValue<t<'value, 'mode>>,
}

type selectorFamilyConfig<'parameter, 'value> = {
  key: string,
  get: 'parameter => fn<getValue<'value>>,
}

type selectorFamilyWithWriteConfig<'parameter, 'value> = {
  key: string,
  get: 'parameter => fn<getValue<'value>>,
  set: 'parameter => fn<setValue<'value>>,
}

type asyncSelectorFamilyConfig<'parameter, 'value> = {
  key: string,
  get: 'parameter => fn<getValue<Js.Promise.t<'value>>>,
}

type asyncSelectorFamilyWithWriteConfig<'parameter, 'value> = {
  key: string,
  get: 'parameter => fn<getValue<Js.Promise.t<'value>>>,
  set: 'parameter => fn<setValue<'value>>,
}

type selectorFamilyConfigFromRecoilValue<'parameter, 'value, 'mode> = {
  key: string,
  get: 'parameter => fn<getValue<t<'value, 'mode>>>,
}

@module("recoil")
external selectorWithWrite: selectorWithWriteConfig<'value> => readWrite<'value> = "selector"

@module("recoil")
external selector: selectorConfig<'value> => readOnly<'value> = "selector"

@module("recoil")
external asyncSelector: asyncSelectorConfig<'value> => readOnly<'value> = "selector"

@module("recoil")
external selectorFromRecoilValue: selectorConfigFromRecoilValue<'value, 'mode> => readOnly<'value> =
  "selector"

@module("recoil")
external selectorFamilyWithWrite: selectorFamilyWithWriteConfig<
  'parameter,
  'value,
> => selectorFamily<'parameter, readWrite<'value>> = "selectorFamily"

@module("recoil")
external selectorFamily: selectorFamilyConfig<'parameter, 'value> => selectorFamily<
  'parameter,
  readOnly<'value>,
> = "selectorFamily"

@module("recoil")
external asyncSelectorFamilyWithWrite: asyncSelectorFamilyWithWriteConfig<
  'parameter,
  'value,
> => selectorFamily<'parameter, readWrite<'value>> = "selectorFamily"

@module("recoil")
external asyncSelectorFamily: asyncSelectorFamilyConfig<'parameter, 'value> => selectorFamily<
  'parameter,
  readOnly<'value>,
> = "selectorFamily"

@module("recoil")
external selectorFamilyFromRecoilValue: selectorFamilyConfigFromRecoilValue<
  'parameter,
  'value,
  'mode,
> => selectorFamily<'parameter, readOnly<'value>> = "selectorFamily"

// React Root component
module RecoilRoot: {
  type initializeStateParams = {set: 'value 'mode. (t<'value, 'mode>, 'value) => unit}
  type initializeState = initializeStateParams => unit

  @react.component @module("recoil")
  external make: (~initializeState: initializeState=?, ~children: React.element) => React.element =
    "RecoilRoot"
}

module Loadable: {
  module State: {
    type t
    @inline("loading")
    let loading: t
    @inline("hasValue")
    let hasValue: t
    @inline("hasError")
    let hasError: t
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
}

// Hooks
@module("recoil")
external useRecoilState: readWrite<'value> => ('value, ('value => 'value) => unit) =
  "useRecoilState"

@module("recoil")
external useRecoilValue: t<'value, 'mode> => 'value = "useRecoilValue"

@module("recoil")
external useRecoilValueLoadable: t<'value, 'mode> => Loadable.t<'value> = "useRecoilValueLoadable"

type set<'value> = ('value => 'value) => unit

@module("recoil")
external useSetRecoilState: readWrite<'value> => set<'value> = "useSetRecoilState"

type reset = unit => unit

@module("recoil")
external useResetRecoilState: readWrite<'value> => reset = "useResetRecoilState"

type mutableSnapshot = {
  set: 'value 'mode. (t<'value, 'mode>, 'value => 'value) => unit,
  reset: 'value 'mode. t<'value, 'mode> => unit,
}

type rec snapshot = {
  getPromise: 'value 'mode. t<'value, 'mode> => Js.Promise.t<'value>,
  getLoadable: 'value 'mode. t<'value, 'mode> => Loadable.t<'value>,
  map: (mutableSnapshot => unit) => snapshot,
  asyncMap: (mutableSnapshot => Js.Promise.t<unit>) => Js.Promise.t<snapshot>,
}

type callbackParam = {
  snapshot: snapshot,
  gotoSnapshot: snapshot => unit,
  set: 'value. (readWrite<'value>, 'value => 'value) => unit,
  reset: 'value. readWrite<'value> => unit,
}

type callback<'additionalArg, 'returnValue> = 'additionalArg => 'returnValue

@module("recoil")
external useRecoilCallback: (
  @uncurry (callbackParam => callback<'additionalArg, 'returnValue>)
) => callback<'additionalArg, 'returnValue> = "useRecoilCallback"

@module("recoil")
external useRecoilCallback0: (
  @uncurry (callbackParam => callback<'additionalArg, 'returnValue>),
  @as(json`[]`) _,
) => callback<'additionalArg, 'returnValue> = "useRecoilCallback"

@module("recoil")
external useRecoilCallback1: (
  @uncurry (callbackParam => callback<'additionalArg, 'returnValue>),
  array<'a>,
) => callback<'additionalArg, 'returnValue> = "useRecoilCallback"

@module("recoil")
external useRecoilCallback2: (
  @uncurry (callbackParam => callback<'additionalArg, 'returnValue>),
  ('a, 'b),
) => callback<'additionalArg, 'returnValue> = "useRecoilCallback"

@module("recoil")
external useRecoilCallback3: (
  @uncurry (callbackParam => callback<'additionalArg, 'returnValue>),
  ('a, 'b, 'c),
) => callback<'additionalArg, 'returnValue> = "useRecoilCallback"

@module("recoil")
external useRecoilCallback4: (
  @uncurry (callbackParam => callback<'additionalArg, 'returnValue>),
  ('a, 'b, 'c, 'd),
) => callback<'additionalArg, 'returnValue> = "useRecoilCallback"

@module("recoil")
external useRecoilCallback5: (
  @uncurry (callbackParam => callback<'additionalArg, 'returnValue>),
  ('a, 'b, 'c, 'd, 'e),
) => callback<'additionalArg, 'returnValue> = "useRecoilCallback"

module Uncurried: {
  type uncurriedCallback<'additionalArg, 'returnValue> = (. 'additionalArg) => 'returnValue

  @module("recoil")
  external useRecoilCallback: (
    @uncurry (callbackParam => callback<'additionalArg, 'returnValue>)
  ) => uncurriedCallback<'additionalArg, 'returnValue> = "useRecoilCallback"

  @module("recoil")
  external useRecoilCallback0: (
    @uncurry (callbackParam => callback<'additionalArg, 'returnValue>),
    @as(json`[]`) _,
  ) => uncurriedCallback<'additionalArg, 'returnValue> = "useRecoilCallback"

  @module("recoil")
  external useRecoilCallback1: (
    @uncurry (callbackParam => callback<'additionalArg, 'returnValue>),
    array<'a>,
  ) => uncurriedCallback<'additionalArg, 'returnValue> = "useRecoilCallback"

  @module("recoil")
  external useRecoilCallback2: (
    @uncurry (callbackParam => callback<'additionalArg, 'returnValue>),
    ('a, 'b),
  ) => uncurriedCallback<'additionalArg, 'returnValue> = "useRecoilCallback"

  @module("recoil")
  external useRecoilCallback3: (
    @uncurry (callbackParam => callback<'additionalArg, 'returnValue>),
    ('a, 'b, 'c),
  ) => uncurriedCallback<'additionalArg, 'returnValue> = "useRecoilCallback"

  @module("recoil")
  external useRecoilCallback4: (
    @uncurry (callbackParam => callback<'additionalArg, 'returnValue>),
    ('a, 'b, 'c, 'd),
  ) => uncurriedCallback<'additionalArg, 'returnValue> = "useRecoilCallback"

  @module("recoil")
  external useRecoilCallback5: (
    @uncurry (callbackParam => callback<'additionalArg, 'returnValue>),
    ('a, 'b, 'c, 'd, 'e),
  ) => uncurriedCallback<'additionalArg, 'returnValue> = "useRecoilCallback"
}

@module("recoil")
external waitForAll: array<t<'value, 'mode>> => readOnly<array<'value>> = "waitForAll"

@module("recoil")
external waitForAll2: ((t<'v1, 'm1>, t<'v2, 'm2>)) => readOnly<('v1, 'v2)> = "waitForAll"

@module("recoil")
external waitForAll3: ((t<'v1, 'm1>, t<'v2, 'm2>, t<'v3, 'm3>)) => readOnly<('v1, 'v2, 'v3)> =
  "waitForAll"

@module("recoil")
external waitForAll4: ((t<'v1, 'm1>, t<'v2, 'm2>, t<'v3, 'm3>, t<'v4, 'm4>)) => readOnly<(
  'v1,
  'v2,
  'v3,
  'v4,
)> = "waitForAll"

@module("recoil")
external waitForAll5: (
  (t<'v1, 'm1>, t<'v2, 'm2>, t<'v3, 'm3>, t<'v4, 'm4>, t<'v5, 'm5>)
) => readOnly<('v1, 'v2, 'v3, 'v4, 'v5)> = "waitForAll"

@module("recoil")
external waitForAll6: (
  (t<'v1, 'm1>, t<'v2, 'm2>, t<'v3, 'm3>, t<'v4, 'm4>, t<'v5, 'm5>, t<'v6, 'm6>)
) => readOnly<('v1, 'v2, 'v3, 'v4, 'v5, 'v6)> = "waitForAll"

@module("recoil")
external waitForAny: array<t<'value, 'mode>> => readOnly<array<Loadable.t<'value>>> = "waitForAny"

@module("recoil")
external waitForAny2: ((t<'v1, 'm1>, t<'v2, 'm2>)) => readOnly<(Loadable.t<'v1>, Loadable.t<'v2>)> =
  "waitForAny"

@module("recoil")
external waitForAny3: ((t<'v1, 'm1>, t<'v2, 'm2>, t<'v3, 'm3>)) => readOnly<(
  Loadable.t<'v1>,
  Loadable.t<'v2>,
  Loadable.t<'v3>,
)> = "waitForAny"

@module("recoil")
external waitForAny4: ((t<'v1, 'm1>, t<'v2, 'm2>, t<'v3, 'm3>, t<'v4, 'm4>)) => readOnly<(
  Loadable.t<'v1>,
  Loadable.t<'v2>,
  Loadable.t<'v3>,
  Loadable.t<'v4>,
)> = "waitForAny"

@module("recoil")
external waitForAny5: (
  (t<'v1, 'm1>, t<'v2, 'm2>, t<'v3, 'm3>, t<'v4, 'm4>, t<'v5, 'm5>)
) => readOnly<(
  Loadable.t<'v1>,
  Loadable.t<'v2>,
  Loadable.t<'v3>,
  Loadable.t<'v4>,
  Loadable.t<'v5>,
)> = "waitForAny"

@module("recoil")
external waitForAny6: (
  (t<'v1, 'm1>, t<'v2, 'm2>, t<'v3, 'm3>, t<'v4, 'm4>, t<'v5, 'm5>, t<'v6, 'm6>)
) => readOnly<(
  Loadable.t<'v1>,
  Loadable.t<'v2>,
  Loadable.t<'v3>,
  Loadable.t<'v4>,
  Loadable.t<'v5>,
  Loadable.t<'v6>,
)> = "waitForAny"

@module("recoil")
external waitForNone: array<t<'value, 'mode>> => readOnly<array<Loadable.t<'value>>> = "waitForNone"

@module("recoil")
external waitForNone2: ((t<'v1, 'm1>, t<'v2, 'm2>)) => readOnly<(
  Loadable.t<'v1>,
  Loadable.t<'v2>,
)> = "waitForNone"

@module("recoil")
external waitForNone3: ((t<'v1, 'm1>, t<'v2, 'm2>, t<'v3, 'm3>)) => readOnly<(
  Loadable.t<'v1>,
  Loadable.t<'v2>,
  Loadable.t<'v3>,
)> = "waitForNone"

@module("recoil")
external waitForNone4: ((t<'v1, 'm1>, t<'v2, 'm2>, t<'v3, 'm3>, t<'v4, 'm4>)) => readOnly<(
  Loadable.t<'v1>,
  Loadable.t<'v2>,
  Loadable.t<'v3>,
  Loadable.t<'v4>,
)> = "waitForNone"

@module("recoil")
external waitForNone5: (
  (t<'v1, 'm1>, t<'v2, 'm2>, t<'v3, 'm3>, t<'v4, 'm4>, t<'v5, 'm5>)
) => readOnly<(
  Loadable.t<'v1>,
  Loadable.t<'v2>,
  Loadable.t<'v3>,
  Loadable.t<'v4>,
  Loadable.t<'v5>,
)> = "waitForNone"

@module("recoil")
external waitForNone6: (
  (t<'v1, 'm1>, t<'v2, 'm2>, t<'v3, 'm3>, t<'v4, 'm4>, t<'v5, 'm5>, t<'v6, 'm6>)
) => readOnly<(
  Loadable.t<'v1>,
  Loadable.t<'v2>,
  Loadable.t<'v3>,
  Loadable.t<'v4>,
  Loadable.t<'v5>,
  Loadable.t<'v6>,
)> = "waitForNone"

@module("recoil")
external noWait: t<'value, 'mode> => readOnly<Loadable.t<'value>> = "noWait"
