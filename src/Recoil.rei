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
    (~initialState: initializeState=?, ~children: React.element, unit) =>
    React.element =
    "RecoilRoot";
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

type set('value) = ('value => 'value) => unit;

[@bs.module "recoil"]
external useSetRecoilState: readWrite('value) => set('value) =
  "useSetRecoilState";

type reset = unit => unit;

[@bs.module "recoil"]
external useResetRecoilState: readWrite('value) => reset =
  "useResetRecoilState";
