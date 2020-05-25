module RecoilRoot = {
  type initializeState = {
    set: 'value 'mode. (Recoil__Value.t('value, 'mode), 'value) => unit,
  };

  [@react.component] [@bs.module "recoil"]
  external make:
    (~initialState: initializeState=?, ~children: React.element) =>
    React.element =
    "RecoilRoot";
};

[@bs.module "recoil"]
external useRecoilState:
  Recoil__Value.readWrite('value) => ('value, ('value => 'value) => unit) =
  "useRecoilState";

type value('a) = 'a;

[@bs.module "recoil"]
external useRecoilValue: Recoil__Value.t('value, 'mode) => value('value) =
  "useRecoilValue";

type set('a) = ('a => 'a) => unit;

[@bs.module "recoil"]
external useSetRecoilState: Recoil__Value.readWrite('value) => set('value) =
  "useSetRecoilState";

type reset = unit => unit;

[@bs.module "recoil"]
external useResetRecoilState: Recoil__Value.readWrite('value) => reset =
  "useResetRecoilState";

[@bs.module "recoil"]
external useRecoilValueLoadable:
  Recoil__Value.t('value, 'mode) => Recoil__Loadable.t('value) =
  "useRecoilValueLoadable";

type callbackParam = {
  getPromise:
    'value 'mode.
    Recoil__Value.t('value, 'mode) => Js.Promise.t('value),

  set: 'value. (Recoil__Value.readWrite('value), 'value => 'value) => unit,
  reset: 'value. Recoil__Value.readWrite('value) => unit,
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
