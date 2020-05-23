// Value
type readOnlyMode =
  | ReadOnly;

type readWriteMode =
  | ReadWrite;

// A value can either be in read-only mode or in read/write
type t('value, 'mode);
// Shorthands
type readOnly('value) = t('value, readOnlyMode);
type readWrite('value) = t('value, readWriteMode);

// Utility function
[@bs.module "recoil"] external isRecoilValue: 'any => bool = "isRecoilValue";

// Atom creation
type atomConfig('value) = {
  key: string,
  default: 'value,
};

[@bs.module "recoil"]
external atom: atomConfig('value) => readWrite('value) = "atom";

// Selector creation
type getter = {get: 'value 'mode. t('value, 'mode) => 'value};

type getterAndSetter = {
  get: 'value 'mode. t('value, 'mode) => 'value,
  set: 'value. (readWrite('value), 'value) => unit,
};

type selectorConfig('value) = {
  key: string,
  get: getter => 'value,
};

type selectorWithWriteConfig('value) = {
  key: string,
  get: getter => 'value,
  set: (getterAndSetter, 'value) => unit,
};

type asyncSelectorConfig('value) = {
  key: string,
  get: getter => Js.Promise.t('value),
};

[@bs.module "recoil"]
external selectorWithWrite:
  selectorWithWriteConfig('value) => readWrite('value) =
  "selector";

[@bs.module "recoil"]
external selector: selectorConfig('value) => readOnly('value) = "selector";

[@bs.module "recoil"]
external asyncSelector: asyncSelectorConfig('value) => readOnly('value) =
  "selector";

// React Root component
module RecoilRoot: {
  type initializeState = {
    set: 'value 'mode. (t('value, 'mode), 'value) => unit,
  };

  [@react.component] [@bs.module "recoil"]
  external make:
    (~initialState: initializeState=?, ~children: React.element) =>
    React.element =
    "RecoilRoot";
};

module Loadable: {
  module State: {
    type t;
    [@bs.inline "loading"]
    let loading: t;
    [@bs.inline "hasValue"]
    let hasValue: t;
    [@bs.inline "hasError"]
    let hasError: t;
  };

  type t('a);
  [@bs.get] external state: t('value) => State.t = "state";

  [@bs.send] external getValue: t('value) => 'value = "getValue";
  [@bs.send]
  external toPromise: t('value) => Js.Promise.t('value) = "toPromise";

  [@bs.send] [@bs.return undefined_to_opt]
  external valueMaybe: t('value) => option('value) = "valueMaybe";
  [@bs.send] external valueOrThrow: t('value) => 'value = "valueOrThrow";

  [@bs.send] external errorMaybe: t('value) => option('error) = "errorMaybe";
  [@bs.send] external errorOrThrow: t('value) => 'error = "errorOrThrow";

  [@bs.send] [@bs.return undefined_to_opt]
  external promiseMaybe: t('value) => option(Js.Promise.t('value)) =
    "promiseMaybe";
  [@bs.send]
  external promiseOrThrow: t('value) => Js.Promise.t('value) =
    "promiseOrThrow";

  [@bs.send] external map: (t('value), 'value => 'b) => t('b) = "map";
  [@bs.send]
  external mapAsync: (t('value), 'value => Js.Promise.t('b)) => t('b) =
    "map";
};

// Hooks
[@bs.module "recoil"]
external useRecoilState:
  readWrite('value) => ('value, ('value => 'value) => unit) =
  "useRecoilState";

type value('value) = 'value;

[@bs.module "recoil"]
external useRecoilValue: t('value, 'mode) => value('value) =
  "useRecoilValue";

[@bs.module "recoil"]
external useRecoilValueLoadable: t('value, 'mode) => Loadable.t('value) =
  "useRecoilValueLoadable";

type set('value) = ('value => 'value) => unit;

[@bs.module "recoil"]
external useSetRecoilState: readWrite('value) => set('value) =
  "useSetRecoilState";

type reset = unit => unit;

[@bs.module "recoil"]
external useResetRecoilState: readWrite('value) => reset =
  "useResetRecoilState";

type callbackParam = {
  getPromise: 'value 'mode. t('value, 'mode) => Js.Promise.t('value),
  set: 'value. (readWrite('value), 'value => 'value) => unit,
  reset: 'value. readWrite('value) => unit,
};

type callback('additionalArg, 'returnValue) = 'additionalArg => 'returnValue;

[@bs.module "recoil"]
external useRecoilCallback:
  ([@bs.uncurry] ((callbackParam, 'additionalArg) => 'returnValue)) =>
  callback('additionalArg, 'returnValue) =
  "useRecoilCallback";

[@bs.module "recoil"]
external useRecoilCallback0:
  (
    [@bs.uncurry] ((callbackParam, 'additionalArg) => 'returnValue),
    [@bs.as {json|[]|json}] _
  ) =>
  callback('additionalArg, 'returnValue) =
  "useRecoilCallback";

[@bs.module "recoil"]
external useRecoilCallback1:
  (
    [@bs.uncurry] ((callbackParam, 'additionalArg) => 'returnValue),
    array('a)
  ) =>
  callback('additionalArg, 'returnValue) =
  "useRecoilCallback";

[@bs.module "recoil"]
external useRecoilCallback2:
  (
    [@bs.uncurry] ((callbackParam, 'additionalArg) => 'returnValue),
    ('a, 'b)
  ) =>
  callback('additionalArg, 'returnValue) =
  "useRecoilCallback";

[@bs.module "recoil"]
external useRecoilCallback3:
  (
    [@bs.uncurry] ((callbackParam, 'additionalArg) => 'returnValue),
    ('a, 'b, 'c)
  ) =>
  callback('additionalArg, 'returnValue) =
  "useRecoilCallback";

[@bs.module "recoil"]
external useRecoilCallback4:
  (
    [@bs.uncurry] ((callbackParam, 'additionalArg) => 'returnValue),
    ('a, 'b, 'c, 'd)
  ) =>
  callback('additionalArg, 'returnValue) =
  "useRecoilCallback";

[@bs.module "recoil"]
external useRecoilCallback5:
  (
    [@bs.uncurry] ((callbackParam, 'additionalArg) => 'returnValue),
    ('a, 'b, 'c, 'd, 'e)
  ) =>
  callback('additionalArg, 'returnValue) =
  "useRecoilCallback";
