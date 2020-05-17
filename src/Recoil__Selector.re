type getter = {get: 'value 'mode. Recoil__Value.t('value, 'mode) => 'value};

type getterAndSetter = {
  get: 'value 'mode. Recoil__Value.t('value, 'mode) => 'value,
  set: 'value. (Recoil__Value.readWrite('value), 'value) => unit,
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
  selectorWithWriteConfig('value) => Recoil__Value.readWrite('value) =
  "selector";

[@bs.module "recoil"]
external selector: selectorConfig('value) => Recoil__Value.readOnly('value) =
  "selector";

[@bs.module "recoil"]
external asyncSelector:
  asyncSelectorConfig('value) => Recoil__Value.readOnly('value) =
  "selector";
