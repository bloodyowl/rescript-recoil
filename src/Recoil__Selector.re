type getter = {get: 'a. Recoil__Value.t('a) => 'a};

type getterAndSetter = {
  get: 'a. Recoil__Value.t('a) => 'a,
  set: 'a. (Recoil__Value.t('a), 'a) => unit,
};

type selectorConfig('a) = {
  key: string,
  get: getter => 'a,
  set: option((getterAndSetter, 'a) => unit),
};

[@bs.module "recoil"]
external selector: selectorConfig('a) => Recoil__Value.t('a) = "selector";
