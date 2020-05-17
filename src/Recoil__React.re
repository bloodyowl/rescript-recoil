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
