# reason-recoil

![Node.js CI](https://github.com/bloodyowl/reason-recoil/workflows/Node.js%20CI/badge.svg)

> Zero-cost bindings to Facebook's [Recoil](https://recoiljs.org) library

⚠️ These bindings are still in experimental stages, use with caution

## Installation

Run the following command:

```console
$ yarn add reason-recoil
```

Then add `reason-recoil` to your `bsconfig.json`'s dependencies:

```diff
 {
   "bs-dependencies": [
+    "reason-recoil"
   ]
 }
```

## Usage

### Atom

```reason
let textState = Recoil.atom({
  key: "textState",
  default: "",
});
```

### Selector

```reason
let textStateSize = Recoil.selector({
  key: "textStateSize",
  get: ({get}) => {
    let textState = get(textState);
    Js.String.length(textState);
  },
  // optional
  set: Some(({set}, newValue) => {
    set(textState, "");
  })
});
```

### Hooks

#### `useRecoilState`

```reason
let (state, setState) = Recoil.useRecoilState(textState);

state; // read
setState(textState => newTextState); // write
```

#### `useRecoilValue`

> Note: the `Recoil.value` matching is here to force the rules of hooks

```reason
let {Recoil.value: state} = Recoil.useRecoilState(textState);

state; // read
```

#### `useSetRecoilState`

> Note: the `Recoil.set` matching is here to force the rules of hooks

```reason
let {Recoil.set: setState} = Recoil.useSetRecoilState(textState);

setState(textState => newTextState); // write
```

#### `useResetRecoilState`

> Note: the `Recoil.reset` matching is here to force the rules of hooks

```reason
let {Recoil.reset: reset} = Recoil.useResetRecoilState(textState);

reset(); // write
```
