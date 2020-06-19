type atomConfig('value) = {
  key: string,
  default: 'value,
};

type atomFamilyConfig('parameter, 'value) = {
  key: string,
  default: 'parameter => 'value,
};

type atomFamily('parameter, 'value) = 'parameter => 'value;

[@bs.module "recoil"]
external atom: atomConfig('value) => Recoil__Value.readWrite('value) =
  "atom";

[@bs.module "recoil"]
external asyncAtom:
  atomConfig(Js.Promise.t('value)) => Recoil__Value.readWrite('value) =
  "atom";

[@bs.module "recoil"]
external atomFromRecoilValue:
  atomConfig(Recoil__Value.t('value, _)) => Recoil__Value.readWrite('value) =
  "atom";

[@bs.module "recoil"]
external atomFamily:
  atomFamilyConfig('parameter, 'value) =>
  atomFamily('parameter, Recoil__Value.readWrite('value)) =
  "atomFamily";

[@bs.module "recoil"]
external asyncAtomFamily:
  atomFamilyConfig('parameter, Js.Promise.t('value)) =>
  atomFamily('parameter, Recoil__Value.readWrite('value)) =
  "atomFamily";

[@bs.module "recoil"]
external atomFamilyFromRecoilValue:
  atomFamilyConfig('parameter, Recoil__Value.t('value, _)) =>
  atomFamily('parameter, Recoil__Value.readWrite('value)) =
  "atomFamily";
