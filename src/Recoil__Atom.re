type atomConfig('a) = {
  key: string,
  default: 'a,
};

[@bs.module "recoil"]
external atom: atomConfig('a) => Recoil__Value.t('a) = "atom";
