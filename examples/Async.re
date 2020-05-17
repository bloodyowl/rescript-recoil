let currentUserIdState =
  Recoil.atom({key: "currentUserId", default: "bloodyowl"});

type user = {
  id: string,
  username: string,
  avatar: string,
};

let getUserMock = (~id) => {
  Js.Promise.make((~resolve, ~reject as _) => {
    let _ =
      Js.Global.setTimeout(
        () => {
          resolve(.
            Some({
              id,
              username: "User " ++ id,
              avatar: {j|https://avatars.githubusercontent.com/$id?size=64|j},
            }),
          )
        },
        1_000,
      );
    ();
  });
};

let userState =
  Recoil.asyncSelector({
    key: "currentUser",
    get: ({get}) => {
      let id = get(currentUserIdState);
      getUserMock(~id);
    },
  });

module UserIdPicker = {
  [@react.component]
  let make = () => {
    let {Recoil.value: currentUserId} =
      Recoil.useRecoilValue(currentUserIdState);

    let (inputValue, setInputValue) = React.useState(() => currentUserId);
    let {Recoil.set: setCurrentUserIdState} =
      Recoil.useSetRecoilState(currentUserIdState);

    let setUserId = () => {
      setInputValue(_ => "");
      setCurrentUserIdState(_ => inputValue);
    };

    let onChange = event => {
      let value = event->ReactEvent.Form.target##value;
      setInputValue(_ => value);
    };
    <div>
      <p> "Type a GitHub username and press Enter"->React.string </p>
      <input
        type_="text"
        value=inputValue
        onChange
        onKeyDown={event =>
          if (event->ReactEvent.Keyboard.key == "Enter") {
            setUserId();
          }
        }
      />
      <button onClick={_ => setUserId()}> "Set"->React.string </button>
    </div>;
  };
};

module UserCard = {
  [@react.component]
  let make = () => {
    let {Recoil.value: user} = Recoil.useRecoilValue(userState);

    switch (user) {
    | Some(user) =>
      <h1>
        <img src={user.avatar} width="24" height="24" />
        " "->React.string
        <strong> user.username->React.string </strong>
      </h1>
    | None => "No user selected"->React.string
    };
  };
};

module App = {
  [@react.component]
  let make = () => {
    <>
      <UserIdPicker />
      <React.Suspense fallback={"Loading ..."->React.string}>
        <UserCard />
      </React.Suspense>
    </>;
  };
};

ReactDOMRe.renderToElementWithId(
  <Recoil.RecoilRoot> <App /> </Recoil.RecoilRoot>,
  "root",
);
