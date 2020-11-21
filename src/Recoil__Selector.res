type getter = {get: 'value 'mode. Recoil__Value.t<'value, 'mode> => 'value}

type getterAndSetter = {
  get: 'value 'mode. Recoil__Value.t<'value, 'mode> => 'value,
  set: 'value. (Recoil__Value.readWrite<'value>, 'value => 'value) => unit,
  reset: 'value. Recoil__Value.readWrite<'value> => unit,
}

type getValue<'value> = getter => 'value
type setValue<'value> = (getterAndSetter, 'value) => unit

type selectorFamily<'parameter, 'value> = 'parameter => 'value

type selectorConfig<'value> = {
  key: string,
  get: getValue<'value>,
}

type selectorWithWriteConfig<'value> = {
  key: string,
  get: getter => 'value,
  set: setValue<'value>,
}

@unboxed
type fn<'a> = Fn('a)

type asyncSelectorConfig<'value> = {
  key: string,
  get: getValue<Js.Promise.t<'value>>,
}

type selectorConfigFromRecoilValue<'value, 'mode> = {
  key: string,
  get: getValue<Recoil__Value.t<'value, 'mode>>,
}

type selectorFamilyConfig<'parameter, 'value> = {
  key: string,
  get: 'parameter => fn<getValue<'value>>,
}

type selectorFamilyWithWriteConfig<'parameter, 'value> = {
  key: string,
  get: 'parameter => fn<getValue<'value>>,
  set: 'parameter => fn<setValue<'value>>,
}

type asyncSelectorFamilyConfig<'parameter, 'value> = {
  key: string,
  get: 'parameter => fn<getValue<Js.Promise.t<'value>>>,
}

type asyncSelectorFamilyWithWriteConfig<'parameter, 'value> = {
  key: string,
  get: 'parameter => fn<getValue<Js.Promise.t<'value>>>,
  set: 'parameter => fn<setValue<'value>>,
}

type selectorFamilyConfigFromRecoilValue<'parameter, 'value, 'mode> = {
  key: string,
  get: 'parameter => fn<getValue<Recoil__Value.t<'value, 'mode>>>,
}

@bs.module("recoil")
external selectorWithWrite: selectorWithWriteConfig<'value> => Recoil__Value.readWrite<'value> =
  "selector"

@bs.module("recoil")
external selector: selectorConfig<'value> => Recoil__Value.readOnly<'value> = "selector"

@bs.module("recoil")
external asyncSelector: asyncSelectorConfig<'value> => Recoil__Value.readOnly<'value> = "selector"

@bs.module("recoil")
external selectorFromRecoilValue: selectorConfigFromRecoilValue<
  'value,
  'mode,
> => Recoil__Value.readOnly<'value> = "selector"

@bs.module("recoil")
external selectorFamilyWithWrite: selectorFamilyWithWriteConfig<
  'parameter,
  'value,
> => selectorFamily<'parameter, Recoil__Value.readWrite<'value>> = "selectorFamily"

@bs.module("recoil")
external selectorFamily: selectorFamilyConfig<'parameter, 'value> => selectorFamily<
  'parameter,
  Recoil__Value.readOnly<'value>,
> = "selectorFamily"

@bs.module("recoil")
external asyncSelectorFamily: asyncSelectorFamilyConfig<'parameter, 'value> => selectorFamily<
  'parameter,
  Recoil__Value.readOnly<'value>,
> = "selectorFamily"

@bs.module("recoil")
external asyncSelectorFamilyWithWrite: asyncSelectorFamilyWithWriteConfig<
  'parameter,
  'value,
> => selectorFamily<'parameter, Recoil__Value.readWrite<'value>> = "selectorFamily"

@bs.module("recoil")
external selectorFamilyFromRecoilValue: selectorFamilyConfigFromRecoilValue<
  'parameter,
  'value,
  'mode,
> => selectorFamily<'parameter, Recoil__Value.readOnly<'value>> = "selectorFamily"
