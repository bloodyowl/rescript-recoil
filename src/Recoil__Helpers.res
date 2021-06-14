@module("recoil")
external waitForAll: array<Recoil__Value.t<'value, 'mode>> => Recoil__Value.readOnly<
  array<'value>,
> = "waitForAll"

@module("recoil")
external waitForAll2: (
  (Recoil__Value.t<'v1, 'm1>, Recoil__Value.t<'v2, 'm2>)
) => Recoil__Value.readOnly<('v1, 'v2)> = "waitForAll"

@module("recoil")
external waitForAll3: (
  (Recoil__Value.t<'v1, 'm1>, Recoil__Value.t<'v2, 'm2>, Recoil__Value.t<'v3, 'm3>)
) => Recoil__Value.readOnly<('v1, 'v2, 'v3)> = "waitForAll"

@module("recoil")
external waitForAll4: (
  (
    Recoil__Value.t<'v1, 'm1>,
    Recoil__Value.t<'v2, 'm2>,
    Recoil__Value.t<'v3, 'm3>,
    Recoil__Value.t<'v4, 'm4>,
  )
) => Recoil__Value.readOnly<('v1, 'v2, 'v3, 'v4)> = "waitForAll"

@module("recoil")
external waitForAll5: (
  (
    Recoil__Value.t<'v1, 'm1>,
    Recoil__Value.t<'v2, 'm2>,
    Recoil__Value.t<'v3, 'm3>,
    Recoil__Value.t<'v4, 'm4>,
    Recoil__Value.t<'v5, 'm5>,
  )
) => Recoil__Value.readOnly<('v1, 'v2, 'v3, 'v4, 'v5)> = "waitForAll"

@module("recoil")
external waitForAll6: (
  (
    Recoil__Value.t<'v1, 'm1>,
    Recoil__Value.t<'v2, 'm2>,
    Recoil__Value.t<'v3, 'm3>,
    Recoil__Value.t<'v4, 'm4>,
    Recoil__Value.t<'v5, 'm5>,
    Recoil__Value.t<'v6, 'm6>,
  )
) => Recoil__Value.readOnly<('v1, 'v2, 'v3, 'v4, 'v5, 'v6)> = "waitForAll"

@module("recoil")
external waitForAny: array<Recoil__Value.t<'value, 'mode>> => Recoil__Value.readOnly<
  array<Recoil__Loadable.t<'value>>,
> = "waitForAny"

@module("recoil")
external waitForAny2: (
  (Recoil__Value.t<'v1, 'm1>, Recoil__Value.t<'v2, 'm2>)
) => Recoil__Value.readOnly<(Recoil__Loadable.t<'v1>, Recoil__Loadable.t<'v2>)> = "waitForAny"

@module("recoil")
external waitForAny3: (
  (Recoil__Value.t<'v1, 'm1>, Recoil__Value.t<'v2, 'm2>, Recoil__Value.t<'v3, 'm3>)
) => Recoil__Value.readOnly<(
  Recoil__Loadable.t<'v1>,
  Recoil__Loadable.t<'v2>,
  Recoil__Loadable.t<'v3>,
)> = "waitForAny"

@module("recoil")
external waitForAny4: (
  (
    Recoil__Value.t<'v1, 'm1>,
    Recoil__Value.t<'v2, 'm2>,
    Recoil__Value.t<'v3, 'm3>,
    Recoil__Value.t<'v4, 'm4>,
  )
) => Recoil__Value.readOnly<(
  Recoil__Loadable.t<'v1>,
  Recoil__Loadable.t<'v2>,
  Recoil__Loadable.t<'v3>,
  Recoil__Loadable.t<'v4>,
)> = "waitForAny"

@module("recoil")
external waitForAny5: (
  (
    Recoil__Value.t<'v1, 'm1>,
    Recoil__Value.t<'v2, 'm2>,
    Recoil__Value.t<'v3, 'm3>,
    Recoil__Value.t<'v4, 'm4>,
    Recoil__Value.t<'v5, 'm5>,
  )
) => Recoil__Value.readOnly<(
  Recoil__Loadable.t<'v1>,
  Recoil__Loadable.t<'v2>,
  Recoil__Loadable.t<'v3>,
  Recoil__Loadable.t<'v4>,
  Recoil__Loadable.t<'v5>,
)> = "waitForAny"

@module("recoil")
external waitForAny6: (
  (
    Recoil__Value.t<'v1, 'm1>,
    Recoil__Value.t<'v2, 'm2>,
    Recoil__Value.t<'v3, 'm3>,
    Recoil__Value.t<'v4, 'm4>,
    Recoil__Value.t<'v5, 'm5>,
    Recoil__Value.t<'v6, 'm6>,
  )
) => Recoil__Value.readOnly<(
  Recoil__Loadable.t<'v1>,
  Recoil__Loadable.t<'v2>,
  Recoil__Loadable.t<'v3>,
  Recoil__Loadable.t<'v4>,
  Recoil__Loadable.t<'v5>,
  Recoil__Loadable.t<'v6>,
)> = "waitForAny"

@module("recoil")
external waitForNone: array<Recoil__Value.t<'value, 'mode>> => Recoil__Value.readOnly<
  array<Recoil__Loadable.t<'value>>,
> = "waitForNone"

@module("recoil")
external waitForNone2: (
  (Recoil__Value.t<'v1, 'm1>, Recoil__Value.t<'v2, 'm2>)
) => Recoil__Value.readOnly<(Recoil__Loadable.t<'v1>, Recoil__Loadable.t<'v2>)> = "waitForNone"

@module("recoil")
external waitForNone3: (
  (Recoil__Value.t<'v1, 'm1>, Recoil__Value.t<'v2, 'm2>, Recoil__Value.t<'v3, 'm3>)
) => Recoil__Value.readOnly<(
  Recoil__Loadable.t<'v1>,
  Recoil__Loadable.t<'v2>,
  Recoil__Loadable.t<'v3>,
)> = "waitForNone"

@module("recoil")
external waitForNone4: (
  (
    Recoil__Value.t<'v1, 'm1>,
    Recoil__Value.t<'v2, 'm2>,
    Recoil__Value.t<'v3, 'm3>,
    Recoil__Value.t<'v4, 'm4>,
  )
) => Recoil__Value.readOnly<(
  Recoil__Loadable.t<'v1>,
  Recoil__Loadable.t<'v2>,
  Recoil__Loadable.t<'v3>,
  Recoil__Loadable.t<'v4>,
)> = "waitForNone"

@module("recoil")
external waitForNone5: (
  (
    Recoil__Value.t<'v1, 'm1>,
    Recoil__Value.t<'v2, 'm2>,
    Recoil__Value.t<'v3, 'm3>,
    Recoil__Value.t<'v4, 'm4>,
    Recoil__Value.t<'v5, 'm5>,
  )
) => Recoil__Value.readOnly<(
  Recoil__Loadable.t<'v1>,
  Recoil__Loadable.t<'v2>,
  Recoil__Loadable.t<'v3>,
  Recoil__Loadable.t<'v4>,
  Recoil__Loadable.t<'v5>,
)> = "waitForNone"

@module("recoil")
external waitForNone6: (
  (
    Recoil__Value.t<'v1, 'm1>,
    Recoil__Value.t<'v2, 'm2>,
    Recoil__Value.t<'v3, 'm3>,
    Recoil__Value.t<'v4, 'm4>,
    Recoil__Value.t<'v5, 'm5>,
    Recoil__Value.t<'v6, 'm6>,
  )
) => Recoil__Value.readOnly<(
  Recoil__Loadable.t<'v1>,
  Recoil__Loadable.t<'v2>,
  Recoil__Loadable.t<'v3>,
  Recoil__Loadable.t<'v4>,
  Recoil__Loadable.t<'v5>,
  Recoil__Loadable.t<'v6>,
)> = "waitForNone"

@module("recoil")
external noWait: Recoil__Value.t<'value, 'mode> => Recoil__Value.readOnly<
  Recoil__Loadable.t<'value>,
> = "noWait"
