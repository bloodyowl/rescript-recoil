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
        set: None,
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
    let {Recoil.value: atom4} = Recoil.useRecoilValue(atom4);

    <div> <strong> atom4->React.int </strong> </div>;
  };
};

module UseSetRecoilStateComponent = {
  [@react.component]
  let make = () => {
    let {Recoil.set: setAtom4} = Recoil.useSetRecoilState(atom4);
    let {Recoil.reset: resetAtom4} = Recoil.useResetRecoilState(atom4);

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
});
