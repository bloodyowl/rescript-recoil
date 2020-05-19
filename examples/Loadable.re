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
          resolve(. {
            id,
            username: "User " ++ id,
            avatar: {j|https://avatars.githubusercontent.com/$id?size=64|j},
          })
        },
        1000,
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
    let currentUserId = Recoil.useRecoilValue(currentUserIdState);

    let (inputValue, setInputValue) = React.useState(() => currentUserId);
    let setCurrentUserIdState = Recoil.useSetRecoilState(currentUserIdState);

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
    let userLoadable = Recoil.useRecoilValueLoadable(userState);

    React.useEffect1(
      () => {
        /**
         * For demonstrating how to use the toPromise function.
         * It's actually not needed since data will be fetched
         * when component gets mounted.
         */
        userLoadable.toPromise(.)
        |> Js.Promise.then_(user => {
             Js.log(user);
             Js.Promise.resolve();
           })
        |> ignore;
        None;
      },
      [|userLoadable|],
    );

    switch (Recoil.State.view(userLoadable.state)) {
    | Loading => "Loading ..."->React.string
    | HasValue =>
      let user = userLoadable.getValue(.);
      <h1>
        <img src={user.avatar} width="24" height="24" />
        " "->React.string
        <strong> user.username->React.string </strong>
      </h1>;
    | HasError => "Error"->React.string
    };
  };
};

module App = {
  [@react.component]
  let make = () => {
    <> <UserIdPicker /> <UserCard /> </>;
  };
};

ReactDOMRe.renderToElementWithId(
  <Recoil.RecoilRoot> <App /> </Recoil.RecoilRoot>,
  "root",
);