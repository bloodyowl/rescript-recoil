# reason-recoil

![Node.js CI](https://github.com/bloodyowl/reason-recoil/workflows/Node.js%20CI/badge.svg)

> Zero-cost bindings to Facebook's [Recoil](https://recoiljs.org) library

⚠️ These bindings are still in experimental stages, use with caution

## Installation

Run the following command:

```console
$ yarn add recoil reason-recoil
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

A nice feature the OCaml type-system enables is the ability to differenciate Recoil values between the ones that can **only read state** with the ones that can **write state**. This way, you **can't** use hooks with write capabilities with a read-only value.

#### With read only capabilities

```reason
let textStateSize = Recoil.selector({
  key: "textStateSize",
  get: ({get}) => {
    let textState = get(textState);
    Js.String.length(textState);
  },
});
```

#### With write capabilities

```reason
let textStateSize = Recoil.selector({
  key: "textStateSize",
  get: ({get}) => {
    let textState = get(textState);
    Js.String.length(textState);
  },
  set: ({set}, newSize) => {
    let currentTextState = get(textState);
    set(textState, currentTextState->Js.String.slice(~from=0, ~to_=newSize));
  }
});
```

#### Async

```reason
let user = Recoil.asyncSelector({
  key: "user",
  get: ({get}) => {
    fetchUser(get(currentUserId))
  },
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

```reason
let state = Recoil.useRecoilState(textState);

state; // read
```

#### `useSetRecoilState`

```reason
let setState = Recoil.useSetRecoilState(textState);

setState(textState => newTextState); // write
```

#### `useResetRecoilState`

```reason
let reset = Recoil.useResetRecoilState(textState);

reset(); // write
```

## Examples

The [Recoil Basic Tutorial](https://recoiljs.org/docs/basic-tutorial/intro) has been made in ReasonReact: [check the source](./examples/TodoList.re)!

You can run it using:

```console
$ yarn examples
```

and going to [http://localhost:8000/TodoList.html](http://localhost:8000/TodoList.html)

### Memoization

In the [Recoil introduction video](https://www.youtube.com/watch?v=_ISAA_Jt9kI&feature=emb_title), it is recommanded to use memoization in order to be able to create atoms on the fly, here's a recipe using [Belt](https://reasonml.org/apis/javascript/latest/belt):

```reason
open Belt;

let memoizeByString = f => {
  // Create the map where we'll store the values
  let map = MutableMap.String.make();
  // Return a function that takes a string and returns a value
  // from the cache or the function
  id => {
    switch (map->MutableMap.String.get(id)) {
    | Some(value) => value
    | None =>
      let value = f(id);
      map->MutableMap.String.set(id, value);
      value;
    };
  };
};
```

Then, you can create a function that gets or creates the right atom:

```reason
type t = {
  id: string,
  value: string,
  isCompleted: bool,
};

let todoItemById =
  memoizeByString(id => {
    Recoil.atom({
      key: {j|todo.$id|j},
      default: {
        id,
        value: "",
        isCompleted: false,
      },
    })
  });
```

And use it within a React component:

```reason
[@react.component]
let make = (~todoId) => {
  let (todo, setTodo) = Recoil.useRecoilState(todoItemById(id));

  // ...
  <>
    {todo.value->React.string}
  </>
};
```
