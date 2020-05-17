module RecoilRoot = {
  type initializeState = {set: 'a 'b. (Recoil__Value.t('a, 'b), 'a) => unit};

  [@react.component] [@bs.module "recoil"]
  external make:
    (~initialState: initializeState=?, ~children: React.element) =>
    React.element =
    "RecoilRoot";
};

[@bs.module "recoil"]
external useRecoilState:
  Recoil__Value.readWrite('a) => ('a, ('a => 'a) => unit) =
  "useRecoilState";

type value('a) = 'a;

[@bs.module "recoil"]
external useRecoilValue: Recoil__Value.t('a, 'b) => value('a) =
  "useRecoilValue";

type set('a) = ('a => 'a) => unit;

[@bs.module "recoil"]
external useSetRecoilState: Recoil__Value.readWrite('a) => set('a) =
  "useSetRecoilState";

type reset = unit => unit;

[@bs.module "recoil"]
external useResetRecoilState: Recoil__Value.readWrite('a) => reset =
  "useResetRecoilState";
