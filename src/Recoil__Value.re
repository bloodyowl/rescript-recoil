type readOnly;
type readWrite;

type t('a, 'mode) =
  | ReadWrite: t('a, readWrite)
  | ReadOnly: t('a, readOnly);

[@bs.module "recoil"] external isRecoilValue: 'a => bool = "isRecoilValue";
