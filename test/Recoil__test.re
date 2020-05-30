open Belt;
open TestFramework;

describe("Recoil.atom", ({test}) => {
  test("Can create an atom", ({expect}) => {
    let atom = Recoil.atom({key: "Test.Atom.1", default: 0});

    expect.bool(Recoil.isRecoilValue(atom)).toBeTrue();
  })
});

describe("Recoil.selector", ({test}) => {
  test("Can create a selector", ({expect}) => {
    let atom2 = Recoil.atom({key: "Test.Atom.2", default: 0});

    let selector =
      Recoil.selector({
        key: "Test.Selector.1",
        get: ({get}) => {
          let atom1 = get(atom2);
          atom1 + 1;
        },
      });

    expect.bool(Recoil.isRecoilValue(selector)).toBeTrue();
  })
});

open ReactTestUtils;

let atom3 = Recoil.atom({key: "Test.Atom.3", default: 0});

module UseRecoilStateComponent = {
  [@react.component]
  let make = () => {
    let (atom3, setAtom3) = Recoil.useRecoilState(atom3);

    <div>
      <strong> atom3->React.int </strong>
      <button onClick={_ => setAtom3(atom3 => atom3 + 1)}>
        "Increment"->React.string
      </button>
    </div>;
  };
};

module OtherUseRecoilStateComponent = {
  [@react.component]
  let make = () => {
    let (atom3, _setAtom3) = Recoil.useRecoilState(atom3);

    <div> <i> atom3->React.int </i> </div>;
  };
};

describe("Recoil.useRecoilState", ({test, beforeEach, afterEach}) => {
  let container = ref(None);

  beforeEach(prepareContainer(container));
  afterEach(cleanupContainer(container));

  test("Can read and set value", ({expect}) => {
    let container = getContainer(container);

    act(() => {
      ReactDOMRe.render(
        <Recoil.RecoilRoot>
          <UseRecoilStateComponent />
          <OtherUseRecoilStateComponent />
        </Recoil.RecoilRoot>,
        container,
      )
    });

    let atomValue =
      container->DOM.findBySelectorAndTextContent("strong", "0");

    expect.bool(atomValue->Option.isSome).toBeTrue();

    let otherAtomValue =
      container->DOM.findBySelectorAndTextContent("i", "0");

    expect.bool(otherAtomValue->Option.isSome).toBeTrue();

    let button =
      container->DOM.findBySelectorAndTextContent("button", "Increment");

    act(() => {
      switch (button) {
      | Some(button) => Simulate.click(button)
      | None => ()
      }
    });

    let previousAtomValue =
      container->DOM.findBySelectorAndTextContent("strong", "0");

    expect.bool(previousAtomValue->Option.isSome).toBeFalse();

    let atomValue =
      container->DOM.findBySelectorAndTextContent("strong", "1");

    expect.bool(atomValue->Option.isSome).toBeTrue();

    let previousOtherAtomValue =
      container->DOM.findBySelectorAndTextContent("i", "0");

    expect.bool(previousOtherAtomValue->Option.isSome).toBeFalse();

    let otherAtomValue =
      container->DOM.findBySelectorAndTextContent("i", "1");

    expect.bool(otherAtomValue->Option.isSome).toBeTrue();
  });
});

let atom4 = Recoil.atom({key: "Test.Atom.4", default: 0});

module UseRecoilValueComponent = {
  [@react.component]
  let make = () => {
    let atom4 = Recoil.useRecoilValue(atom4);

    <div> <strong> atom4->React.int </strong> </div>;
  };
};

module UseSetRecoilStateComponent = {
  [@react.component]
  let make = () => {
    let setAtom4 = Recoil.useSetRecoilState(atom4);
    let resetAtom4 = Recoil.useResetRecoilState(atom4);

    <div>
      <button onClick={_ => setAtom4(atom4 => atom4 + 1)}>
        "Increment"->React.string
      </button>
      <button onClick={_ => resetAtom4()}> "Reset"->React.string </button>
    </div>;
  };
};

describe(
  "Recoil.useRecoilValue/useSetRecoilState", ({test, beforeEach, afterEach}) => {
  let container = ref(None);

  beforeEach(prepareContainer(container));
  afterEach(cleanupContainer(container));

  test("Can read and set value", ({expect}) => {
    let container = getContainer(container);

    act(() => {
      ReactDOMRe.render(
        <Recoil.RecoilRoot>
          <UseRecoilValueComponent />
          <UseSetRecoilStateComponent />
        </Recoil.RecoilRoot>,
        container,
      )
    });

    let atomValue =
      container->DOM.findBySelectorAndTextContent("strong", "0");

    expect.bool(atomValue->Option.isSome).toBeTrue();

    let button =
      container->DOM.findBySelectorAndTextContent("button", "Increment");

    act(() => {
      switch (button) {
      | Some(button) => Simulate.click(button)
      | None => ()
      }
    });

    let previousAtomValue =
      container->DOM.findBySelectorAndTextContent("strong", "0");

    expect.bool(previousAtomValue->Option.isSome).toBeFalse();

    let atomValue =
      container->DOM.findBySelectorAndTextContent("strong", "1");

    expect.bool(atomValue->Option.isSome).toBeTrue();

    let button =
      container->DOM.findBySelectorAndTextContent("button", "Reset");

    act(() => {
      switch (button) {
      | Some(button) => Simulate.click(button)
      | None => ()
      }
    });

    let previousAtomValue =
      container->DOM.findBySelectorAndTextContent("strong", "1");

    expect.bool(previousAtomValue->Option.isSome).toBeFalse();

    let atomValue =
      container->DOM.findBySelectorAndTextContent("strong", "0");

    expect.bool(atomValue->Option.isSome).toBeTrue();
  });

  test("Can take a default store value", ({expect}) => {
    let container = getContainer(container);

    act(() => {
      ReactDOMRe.render(
        <Recoil.RecoilRoot initializeState={({set}) => {set(atom4, 60)}}>
          <UseRecoilValueComponent />
        </Recoil.RecoilRoot>,
        container,
      )
    });

    let atomValue =
      container->DOM.findBySelectorAndTextContent("strong", "60");

    expect.bool(atomValue->Option.isSome).toBeTrue();
  });
});

let username = Recoil.atom({key: "Test.Username", default: ""});
let usernameSize =
  Recoil.selectorWithWrite({
    key: "Test.UsernameSize",
    get: ({get}) => {
      let username = get(username);
      username->Js.String.length;
    },
    set: ({set, get}, newValue) => {
      set(username, get(username)->Js.String.slice(~from=0, ~to_=newValue));
    },
  });
let usernameSizeReadOnly =
  Recoil.selector({
    key: "Test.UsernameSizeReadOnly",
    get: ({get}) => {
      let username = get(username);
      username->Js.String.length;
    },
  });

module UseRecoilStateComponentWithSelector = {
  [@react.component]
  let make = () => {
    let (username, setUsername) = Recoil.useRecoilState(username);
    let (usernameSize, setUsernameSize) =
      Recoil.useRecoilState(usernameSize);
    // Try switching the following line for useRecoilState to check the compile error
    let _usernameSizeReadOnly = Recoil.useRecoilValue(usernameSizeReadOnly);
    <div>
      <input
        onChange={event => {
          let newValue = event->ReactEvent.Form.target##value;
          setUsername(_ => newValue);
        }}
        value=username
      />
      <strong> usernameSize->React.int </strong>
      <button onClick={_ => setUsernameSize(_ => 1)}>
        "Slice to 1"->React.string
      </button>
    </div>;
  };
};

external domElementToJsT: Dom.element => Js.t({..}) = "%identity";

// The following test outputs a warning, but that doesn't look like
// to be related to our bindings: https://github.com/facebookexperimental/Recoil/issues/31
describe(
  "Recoil.useRecoilState with selector", ({test, beforeEach, afterEach}) => {
  let container = ref(None);

  beforeEach(prepareContainer(container));
  afterEach(cleanupContainer(container));

  test("Can read and set value", ({expect}) => {
    let container = getContainer(container);

    act(() => {
      ReactDOMRe.render(
        <Recoil.RecoilRoot>
          <UseRecoilStateComponentWithSelector />
        </Recoil.RecoilRoot>,
        container,
      )
    });

    let selectorValue =
      container->DOM.findBySelectorAndTextContent("strong", "0");

    expect.bool(selectorValue->Option.isSome).toBeTrue();

    let input = container->DOM.findBySelector("input");

    act(() => {
      switch (input) {
      | Some(input) => input->Simulate.changeWithValue("bloodyowl")
      | None => ()
      }
    });

    let oldSelectorValue =
      container->DOM.findBySelectorAndTextContent("strong", "0");

    expect.bool(oldSelectorValue->Option.isSome).toBeFalse();

    let selectorValue =
      container->DOM.findBySelectorAndTextContent("strong", "9");

    expect.bool(selectorValue->Option.isSome).toBeTrue();

    let button =
      container->DOM.findBySelectorAndTextContent("button", "Slice to 1");

    act(() => {
      switch (button) {
      | Some(button) => Simulate.click(button)
      | None => ()
      }
    });

    let oldSelectorValue =
      container->DOM.findBySelectorAndTextContent("strong", "9");

    expect.bool(oldSelectorValue->Option.isSome).toBeFalse();

    let selectorValue =
      container->DOM.findBySelectorAndTextContent("strong", "1");

    expect.bool(selectorValue->Option.isSome).toBeTrue();

    let input = container->DOM.findBySelector("input");

    expect.value(input->Option.map(item => item->domElementToJsT##value)).
      toEqual(
      Some("b"),
    );
  });
});

let atomForCallback =
  Recoil.atom({key: "atomForCallback", default: "HelloWorld"});

module UseRecoilCallbackComponent = {
  [@react.component]
  let make = (~onCallback) => {
    let onClick =
      Recoil.useRecoilCallback0(({getPromise}, _) => {
        let _ =
          getPromise(atomForCallback)
          ->Js.Promise.then_(
              value => {
                onCallback(value);
                Js.Promise.resolve();
              },
              _,
            );
        ();
      });

    <div> <button onClick> "Run callback"->React.string </button> </div>;
  };
};

describe("Recoil.useRecoilCallback", ({testAsync, beforeEach, afterEach}) => {
  let container = ref(None);

  beforeEach(prepareContainer(container));
  afterEach(cleanupContainer(container));

  testAsync("Can read and set value", ({expect, callback}) => {
    let container = getContainer(container);

    act(() => {
      ReactDOMRe.render(
        <Recoil.RecoilRoot>
          <UseRecoilCallbackComponent
            onCallback={value => {
              expect.string(value).toEqual("HelloWorld");
              callback();
            }}
          />
        </Recoil.RecoilRoot>,
        container,
      )
    });

    let button =
      container->DOM.findBySelectorAndTextContent("button", "Run callback");

    act(() => {
      switch (button) {
      | Some(button) => Simulate.click(button)
      | None => ()
      }
    });
  });
});
