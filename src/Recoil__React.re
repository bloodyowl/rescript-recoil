module RecoilRoot = {
  type initializeState = {set: 'a 'b. (Recoil__Value.t('a, 'b), 'a) => unit};

  [@react.component] [@bs.module "recoil"]
  external make:
    (
      ~initialState: option(initializeState)=?,
      ~children: React.element,
      unit
    ) =>
    React.element =
    "RecoilRoot";
};

[@bs.module "recoil"]
external useRecoilState:
  Recoil__Value.t('a, Recoil__Value.readWrite) => ('a, ('a => 'a) => unit) =
  "useRecoilState";

[@unboxed]
type value('a) = {value: 'a};

[@bs.module "recoil"]
external useRecoilValue: Recoil__Value.t('a, 'b) => value('a) =
  "useRecoilValue";

[@unboxed]
type set('a) = {set: ('a => 'a) => unit};

[@bs.module "recoil"]
external useSetRecoilState:
  Recoil__Value.t('a, Recoil__Value.readWrite) => set('a) =
  "useSetRecoilState";

[@unboxed]
type reset = {reset: unit => unit};

[@bs.module "recoil"]
external useResetRecoilState:
  Recoil__Value.t('a, Recoil__Value.readWrite) => reset =
  "useResetRecoilState";
