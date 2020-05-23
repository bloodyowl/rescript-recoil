type t('a);

[@bs.get] external state: t('value) => Recoil__State.t = "state";

[@bs.send] external getValue: t('value) => 'value = "getValue";
[@bs.send]
external toPromise: t('value) => Js.Promise.t('value) = "toPromise";

[@bs.send] [@bs.return undefined_to_opt]
external valueMaybe: t('value) => option('value) = "valueMaybe";
[@bs.send] external valueOrThrow: t('value) => 'value = "valueOrThrow";

[@bs.send] external errorMaybe: t('value) => option('error) = "errorMaybe";
[@bs.send] external errorOrThrow: t('value) => 'error = "errorOrThrow";

[@bs.send] [@bs.return undefined_to_opt]
external promiseMaybe: t('value) => option(Js.Promise.t('value)) =
  "promiseMaybe";
[@bs.send]
external promiseOrThrow: t('value) => Js.Promise.t('value) =
  "promiseOrThrow";

[@bs.send] external map: (t('value), 'value => 'b) => t('b) = "map";
[@bs.send]
external mapAsync: (t('value), 'value => Js.Promise.t('b)) => t('b) = "map";

module State = {
  type t = string;
  [@bs.inline]
  let loading = "loading";
  [@bs.inline]
  let hasValue = "hasValue";
  [@bs.inline]
  let hasError = "hasError";
};
