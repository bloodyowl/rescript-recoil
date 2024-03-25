let currentUserIdState = Recoil.atom({key: "currentUserId", default: "bloodyowl"})

type user = {
  id: string,
  username: string,
  avatar: string,
}

let getUserMock = (~id) =>
  Js.Promise.make((~resolve, ~reject as _) => {
    let _ = Js.Global.setTimeout(() =>
      resolve({
        id,
        username: "User " ++ id,
        avatar: `https://avatars.githubusercontent.com/$id?size=64`, //avatars.githubusercontent.com/$id?size=64|j},
      })
    , 1000)
  })

let userState = Recoil.asyncSelector({
  key: "currentUser",
  get: ({get}) => {
    let id = get(currentUserIdState)
    getUserMock(~id)
  },
})

module UserIdPicker = {
  @react.component
  let make = () => {
    let currentUserId = Recoil.useRecoilValue(currentUserIdState)

    let (inputValue, setInputValue) = React.useState(() => currentUserId)
    let setCurrentUserIdState = Recoil.useSetRecoilState(currentUserIdState)

    let setUserId = () => {
      setInputValue(_ => "")
      setCurrentUserIdState(_ => inputValue)
    }

    let onChange = event => {
      let value = (event->ReactEvent.Form.target)["value"]
      setInputValue(_ => value)
    }
    <div>
      <p> {"Type a GitHub username and press Enter"->React.string} </p>
      <input
        type_="text"
        value=inputValue
        onChange
        onKeyDown={event =>
          if event->ReactEvent.Keyboard.key == "Enter" {
            setUserId()
          }}
      />
      <button onClick={_ => setUserId()}> {"Set"->React.string} </button>
    </div>
  }
}

module UserCard = {
  @react.component
  let make = () => {
    let userLoadable = Recoil.useRecoilValueLoadable(userState)

    React.useEffect1(() => {
      @ocaml.doc("
         * This shows how to use the toPromise function.
         * It's actually not needed since data will be fetched
         * when component gets mounted.
         ")
      ignore(Js.Promise.then_(user => {
          Js.log(user)
          Js.Promise.resolve()
        }, Recoil.Loadable.toPromise(userLoadable)))

      None
    }, [userLoadable])

    switch Recoil.Loadable.state(userLoadable) {
    | loading if loading == Recoil.Loadable.State.loading => "Loading ..."->React.string
    | error if error == Recoil.Loadable.State.hasError => "Error"->React.string
    | _ =>
      let user = Recoil.Loadable.getValue(userLoadable)
      <h1>
        <img src=user.avatar width="24" height="24" />
        {" "->React.string}
        <strong> {user.username->React.string} </strong>
      </h1>
    }
  }
}

module App = {
  @react.component
  let make = () => <>
    <UserIdPicker />
    <UserCard />
  </>
}

switch ReactDOM.querySelector("#root") {
| Some(container) => {
    let rootElement = ReactDOM.Client.createRoot(container)
    ReactDOM.Client.Root.render(
      rootElement,
      <Recoil.RecoilRoot>
        <App />
      </Recoil.RecoilRoot>,
    )
  }
| None => ()
}
