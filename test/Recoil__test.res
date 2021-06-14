open Belt
open Test

let isTrue = (~message=?, value) => assertion(~message?, (a, b) => a === b, value, true)
let isFalse = (~message=?, value) => assertion(~message?, (a, b) => a === b, value, false)
let stringEqual = (~message=?, a: string, b: string) =>
  assertion(~message?, (a, b) => a === b, a, b)

test("Recoil.atom", () => {
  let atom = Recoil.atom({key: "Test.Atom.1", default: 0})
  isTrue(~message="Can create atom", Recoil.isRecoilValue(atom))
})

test("Recoil.selector", () => {
  let atom2 = Recoil.atom({key: "Test.Atom.2", default: 0})
  let selector = Recoil.selector({
    key: "Test.Selector.1",
    get: ({get}) => {
      let atom1 = get(atom2)
      atom1 + 1
    },
  })
  isTrue(~message="Can create selector", Recoil.isRecoilValue(selector))
})

open ReactTestUtils

let atom3 = Recoil.atom({key: "Test.Atom.3", default: 0})

module UseRecoilStateComponent = {
  @react.component
  let make = () => {
    let (atom3, setAtom3) = Recoil.useRecoilState(atom3)
    <div>
      <strong> {atom3->React.int} </strong>
      <button onClick={_ => setAtom3(atom3 => atom3 + 1)}> {"Increment"->React.string} </button>
    </div>
  }
}

module OtherUseRecoilStateComponent = {
  @react.component
  let make = () => {
    let (atom3, _setAtom3) = Recoil.useRecoilState(atom3)

    <div> <i> {atom3->React.int} </i> </div>
  }
}

@val external window: {..} = "window"
@send external remove: Dom.element => unit = "remove"

let createContainer = () => {
  let containerElement: Dom.element = window["document"]["createElement"](. "div")
  let _ = window["document"]["body"]["appendChild"](. containerElement)
  containerElement
}

let cleanupContainer = container => {
  ReactDOM.unmountComponentAtNode(container)
  remove(container)
}

let testWithReact = testWith(~setup=createContainer, ~teardown=cleanupContainer)
let testAsyncWithReact = testAsyncWith(~setup=createContainer, ~teardown=cleanupContainer)

testWithReact("Recoil.useRecoilState: Can read and set value", container => {
  act(() =>
    ReactDOM.render(
      <Recoil.RecoilRoot>
        <UseRecoilStateComponent /> <OtherUseRecoilStateComponent />
      </Recoil.RecoilRoot>,
      container,
    )
  )

  let atomValue = container->DOM.findBySelectorAndTextContent("strong", "0")
  isTrue(atomValue->Option.isSome)

  let otherAtomValue = container->DOM.findBySelectorAndTextContent("i", "0")
  isTrue(otherAtomValue->Option.isSome)

  let button = container->DOM.findBySelectorAndTextContent("button", "Increment")

  act(() =>
    switch button {
    | Some(button) => Simulate.click(button)
    | None => ()
    }
  )

  let previousAtomValue = container->DOM.findBySelectorAndTextContent("strong", "0")
  isFalse(previousAtomValue->Option.isSome)

  let atomValue = container->DOM.findBySelectorAndTextContent("strong", "1")
  isTrue(atomValue->Option.isSome)

  let previousOtherAtomValue = container->DOM.findBySelectorAndTextContent("i", "0")
  isFalse(previousOtherAtomValue->Option.isSome)

  let otherAtomValue = container->DOM.findBySelectorAndTextContent("i", "1")
  isTrue(otherAtomValue->Option.isSome)
})

let atom4 = Recoil.atom({key: "Test.Atom.4", default: 0})

module UseRecoilValueComponent = {
  @react.component
  let make = () => {
    let atom4 = Recoil.useRecoilValue(atom4)

    <div> <strong> {atom4->React.int} </strong> </div>
  }
}

module UseSetRecoilStateComponent = {
  @react.component
  let make = () => {
    let setAtom4 = Recoil.useSetRecoilState(atom4)
    let resetAtom4 = Recoil.useResetRecoilState(atom4)

    <div>
      <button onClick={_ => setAtom4(atom4 => atom4 + 1)}> {"Increment"->React.string} </button>
      <button onClick={_ => resetAtom4()}> {"Reset"->React.string} </button>
    </div>
  }
}

testWithReact("Recoil.useRecoilValue/useSetRecoilState can read and set value", container => {
  act(() =>
    ReactDOM.render(
      <Recoil.RecoilRoot>
        <UseRecoilValueComponent /> <UseSetRecoilStateComponent />
      </Recoil.RecoilRoot>,
      container,
    )
  )

  let atomValue = container->DOM.findBySelectorAndTextContent("strong", "0")

  isTrue(atomValue->Option.isSome)

  let button = container->DOM.findBySelectorAndTextContent("button", "Increment")

  act(() =>
    switch button {
    | Some(button) => Simulate.click(button)
    | None => ()
    }
  )

  let previousAtomValue = container->DOM.findBySelectorAndTextContent("strong", "0")

  isFalse(previousAtomValue->Option.isSome)

  let atomValue = container->DOM.findBySelectorAndTextContent("strong", "1")

  isTrue(atomValue->Option.isSome)

  let button = container->DOM.findBySelectorAndTextContent("button", "Reset")

  act(() =>
    switch button {
    | Some(button) => Simulate.click(button)
    | None => ()
    }
  )

  let previousAtomValue = container->DOM.findBySelectorAndTextContent("strong", "1")

  isFalse(previousAtomValue->Option.isSome)

  let atomValue = container->DOM.findBySelectorAndTextContent("strong", "0")

  isTrue(atomValue->Option.isSome)
})

testWithReact(
  "Recoil.useRecoilValue/useSetRecoilState can take a default store value",
  container => {
    act(() =>
      ReactDOM.render(
        <Recoil.RecoilRoot initializeState={({set}) => set(atom4, 60)}>
          <UseRecoilValueComponent />
        </Recoil.RecoilRoot>,
        container,
      )
    )

    let atomValue = container->DOM.findBySelectorAndTextContent("strong", "60")

    isTrue(atomValue->Option.isSome)
  },
)

let username = Recoil.atom({key: "Test.Username", default: ""})
let usernameSize = Recoil.selectorWithWrite({
  key: "Test.UsernameSize",
  get: ({get}) => {
    let username = get(username)
    username->Js.String.length
  },
  set: ({set, get}, newValue) =>
    set(username, _ => get(username)->Js.String.slice(~from=0, ~to_=newValue)),
})
let usernameSizeReadOnly = Recoil.selector({
  key: "Test.UsernameSizeReadOnly",
  get: ({get}) => {
    let username = get(username)
    username->Js.String.length
  },
})

module UseRecoilStateComponentWithSelector = {
  @react.component
  let make = () => {
    let (username, setUsername) = Recoil.useRecoilState(username)
    let (usernameSize, setUsernameSize) = Recoil.useRecoilState(usernameSize)
    // Try switching the following line for useRecoilState to check the compile error
    let _usernameSizeReadOnly = Recoil.useRecoilValue(usernameSizeReadOnly)
    <div>
      <input
        onChange={event => {
          let newValue = (event->ReactEvent.Form.target)["value"]
          setUsername(_ => newValue)
        }}
        value=username
      />
      <strong> {usernameSize->React.int} </strong>
      <button onClick={_ => setUsernameSize(_ => 1)}> {"Slice to 1"->React.string} </button>
    </div>
  }
}

external domElementToJsT: Dom.element => {..} = "%identity"

// The following test outputs a warning, but that doesn't look like
// to be related to our bindings: https://github.com/facebookexperimental/Recoil/issues/31
testWithReact("Recoil.useRecoilState with selector Can read and set value", container => {
  act(() =>
    ReactDOM.render(
      <Recoil.RecoilRoot> <UseRecoilStateComponentWithSelector /> </Recoil.RecoilRoot>,
      container,
    )
  )

  let selectorValue = container->DOM.findBySelectorAndTextContent("strong", "0")

  isTrue(selectorValue->Option.isSome)

  let input = container->DOM.findBySelector("input")

  act(() =>
    switch input {
    | Some(input) => input->Simulate.changeWithValue("bloodyowl")
    | None => ()
    }
  )

  let oldSelectorValue = container->DOM.findBySelectorAndTextContent("strong", "0")

  isFalse(oldSelectorValue->Option.isSome)

  let selectorValue = container->DOM.findBySelectorAndTextContent("strong", "9")

  isTrue(selectorValue->Option.isSome)

  let button = container->DOM.findBySelectorAndTextContent("button", "Slice to 1")

  act(() =>
    switch button {
    | Some(button) => Simulate.click(button)
    | None => ()
    }
  )

  let oldSelectorValue = container->DOM.findBySelectorAndTextContent("strong", "9")

  isFalse(oldSelectorValue->Option.isSome)

  let selectorValue = container->DOM.findBySelectorAndTextContent("strong", "1")

  isTrue(selectorValue->Option.isSome)

  let input = container->DOM.findBySelector("input")

  assertion(
    (a, b) => Option.eq(a, b, (a, b) => a == b),
    input->Option.map(item => (item->domElementToJsT)["value"]),
    Some("b"),
  )
})

let atomForCallback = Recoil.atom({key: "atomForCallback", default: "HelloWorld"})

module UseRecoilCallbackComponent = {
  @react.component
  let make = (~onCallback) => {
    let onClick = Recoil.useRecoilCallback0(({snapshot: {getPromise}}, _) => {
      let _ = getPromise(atomForCallback)->Js.Promise.then_(value => {
        onCallback(value)
        Js.Promise.resolve()
      }, _)
    })

    <div> <button onClick> {"Run callback"->React.string} </button> </div>
  }
}

testAsyncWithReact("Recoil.useRecoilCallback Can read and set value", (container, callback) => {
  act(() =>
    ReactDOM.render(
      <Recoil.RecoilRoot>
        <UseRecoilCallbackComponent
          onCallback={value => {
            stringEqual(value, "HelloWorld")
            callback()
          }}
        />
      </Recoil.RecoilRoot>,
      container,
    )
  )

  let button = container->DOM.findBySelectorAndTextContent("button", "Run callback")

  act(() =>
    switch button {
    | Some(button) => Simulate.click(button)
    | None => ()
    }
  )
})

let atomForUncurriedCallback = Recoil.atom({
  key: "atomForUncurriedCallback",
  default: "HelloWorldUncurried",
})

module UseUncurriedRecoilCallbackComponent = {
  @react.component
  let make = (~onCallback) => {
    let onClick = Recoil.Uncurried.useRecoilCallback0(({snapshot: {getPromise}}, _) => {
      getPromise(atomForUncurriedCallback)->Js.Promise.then_(value => {
        onCallback(value)
        Js.Promise.resolve()
      }, _)->ignore
      ()
    })

    <div> <button onClick={e => onClick(. e)}> {"Run callback"->React.string} </button> </div>
  }
}

testAsyncWithReact("Recoil.Uncurried.useRecoilCallback can read and set value", (
  container,
  callback,
) => {
  act(() =>
    ReactDOM.render(
      <Recoil.RecoilRoot>
        <UseUncurriedRecoilCallbackComponent
          onCallback={value => {
            stringEqual(value, "HelloWorldUncurried")
            callback()
          }}
        />
      </Recoil.RecoilRoot>,
      container,
    )
  )

  let button = container->DOM.findBySelectorAndTextContent("button", "Run callback")

  act(() =>
    switch button {
    | Some(button) => Simulate.click(button)
    | None => ()
    }
  )
})

type user = {
  id: string,
  name: string,
}
let myAtomFamily = Recoil.atomFamily({
  key: "Test.AtomFamily",
  default: param => {id: param, name: "User:" ++ param},
})

let mySelectorFamily = Recoil.selectorFamily({
  key: "Test.SelectorFamily",
  get: param => Fn(({get}) => get(myAtomFamily(param)).name ++ ":Ok"),
})

module UseRecoilAtomSelectorComponent = {
  @react.component
  let make = () => {
    let atom3 = Recoil.useRecoilValue(myAtomFamily("A"))
    let selector3 = Recoil.useRecoilValue(mySelectorFamily("A"))

    <div>
      <strong> {atom3.id->React.string} </strong>
      <span> {atom3.name->React.string} </span>
      <i> {selector3->React.string} </i>
    </div>
  }
}

testWithReact("Recoil.atomFamily/selectorFamily can read value", container => {
  act(() =>
    ReactDOM.render(
      <Recoil.RecoilRoot> <UseRecoilAtomSelectorComponent /> </Recoil.RecoilRoot>,
      container,
    )
  )

  let id = container->DOM.findBySelectorAndTextContent("strong", "A")
  let username = container->DOM.findBySelectorAndTextContent("span", "User:A")
  let selector = container->DOM.findBySelectorAndTextContent("i", "User:A:Ok")

  isTrue(id->Option.isSome)
  isTrue(username->Option.isSome)
  isTrue(selector->Option.isSome)
})

module UseRecoilWaitForAll = {
  let atomWait1 = Recoil.atom({key: "atomWait1", default: "Hello"})
  let atomWait2 = Recoil.atom({key: "atomWait2", default: "World"})
  @react.component
  let make = () => {
    let (hello, world) = Recoil.useRecoilValue(Recoil.waitForAll2((atomWait1, atomWait2)))

    <div> <strong> {(hello ++ world)->React.string} </strong> </div>
  }
}

testWithReact("Recoil.waitForAll can read value", container => {
  act(() =>
    ReactDOM.render(<Recoil.RecoilRoot> <UseRecoilWaitForAll /> </Recoil.RecoilRoot>, container)
  )

  let value = container->DOM.findBySelectorAndTextContent("strong", "HelloWorld")

  isTrue(value->Option.isSome)
})

let atomWithEffect = Recoil.atomWithEffects({
  key: "Test.Atom.atomWithEffect",
  default: 0,
  effects_UNSTABLE: [
    ({setSelf, trigger}) => {
      if trigger == #get {
        setSelf(value => value + 1)
      }
      None
    },
  ],
})

module UseRecoilStateWithEffectComponent = {
  @react.component
  let make = () => {
    let atomWithEffect = Recoil.useRecoilValue(atomWithEffect)
    <div> <strong> {atomWithEffect->React.int} </strong> </div>
  }
}

testWithReact("Recoil.atomWithEffects can run effects", container => {
  act(() =>
    ReactDOM.render(
      <Recoil.RecoilRoot> <UseRecoilStateWithEffectComponent /> </Recoil.RecoilRoot>,
      container,
    )
  )

  let value = container->DOM.findBySelectorAndTextContent("strong", "1")

  isTrue(value->Option.isSome)
})
