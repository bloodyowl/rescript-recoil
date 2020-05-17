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
[@bs.module "recoil"] external isRecoilValue: 'a => bool = "isRecoilValue";

// Atom creation
type atomConfig('a) = {
  key: string,
  default: 'a,
};

[@bs.module "recoil"]
external atom: atomConfig('a) => readWrite('a) = "atom";

// Selector creation
type getter = {get: 'a 'b. t('a, 'b) => 'a};

type getterAndSetter = {
  get: 'a 'b. t('a, 'b) => 'a,
  set: 'a. (readWrite('a), 'a) => unit,
};

type selectorConfig('a) = {
  key: string,
  get: getter => 'a,
};

type selectorWithWriteConfig('a) = {
  key: string,
  get: getter => 'a,
  set: (getterAndSetter, 'a) => unit,
};

type asyncSelectorConfig('a) = {
  key: string,
  get: getter => Js.Promise.t('a),
};

[@bs.module "recoil"]
external selectorWithWrite: selectorWithWriteConfig('a) => readWrite('a) =
  "selector";

[@bs.module "recoil"]
external selector: selectorConfig('a) => readOnly('a) = "selector";

[@bs.module "recoil"]
external asyncSelector: asyncSelectorConfig('a) => readOnly('a) = "selector";

// React Root component
module RecoilRoot: {
  type initializeState = {set: 'a 'b. (Recoil__Value.t('a, 'b), 'a) => unit};

  [@react.component] [@bs.module "recoil"]
  external make:
    (~initialState: initializeState=?, ~children: React.element) =>
    React.element =
    "RecoilRoot";
};

// Hooks
[@bs.module "recoil"]
external useRecoilState: readWrite('a) => ('a, ('a => 'a) => unit) =
  "useRecoilState";

type value('a) = 'a;

[@bs.module "recoil"]
external useRecoilValue: t('a, 'b) => value('a) = "useRecoilValue";

type set('a) = ('a => 'a) => unit;

[@bs.module "recoil"]
external useSetRecoilState: readWrite('a) => set('a) = "useSetRecoilState";

type reset = unit => unit;

[@bs.module "recoil"]
external useResetRecoilState: readWrite('a) => reset = "useResetRecoilState";
