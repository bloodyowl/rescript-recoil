type getter = {get: 'a. Recoil__Value.t('a) => 'a};

type setter('a) = {
  get: 'a. Recoil__Value.t('a) => 'a,
  set: 'a => unit,
};

type selectorConfig('a) = {
  key: string,
  get: getter => 'a,
  set: 'b. option((setter('a), 'b) => unit),
};

[@bs.module "recoil"]
external selector: selectorConfig('a) => Recoil__Value.t('a) = "selector";
