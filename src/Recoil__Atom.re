type atomConfig('value) = {
  key: string,
  default: 'value,
};

[@bs.module "recoil"]
external atom: atomConfig('value) => Recoil__Value.readWrite('value) =
  "atom";
