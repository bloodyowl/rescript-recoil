type readOnly;
type readWrite;

type t('a, 'mode) =
  | ReadWrite: t('a, readOnly)
  | ReadOnly: t('a, readWrite);

[@bs.module "recoil"] external isRecoilValue: 'a => bool = "isRecoilValue";
