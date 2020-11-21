open Belt

let id = ref(0)
let getId = () => {
  incr(id)
  id.contents
}

type todo = {
  id: int,
  text: string,
  isComplete: bool,
}

let todoListState = Recoil.atom({key: "todoListState", default: []})

type todoListFilter =
  | ShowAll
  | ShowCompleted
  | ShowUncompleted

let todoListFilterState = Recoil.atom({key: "todoListFilterState", default: ShowAll})

let filteredTodoListState = Recoil.selector({
  key: "filteredTodoListState",
  get: ({get}) => {
    let filter = get(todoListFilterState)
    let list = get(todoListState)
    switch filter {
    | ShowCompleted => list->Array.keep(item => item.isComplete)
    | ShowUncompleted => list->Array.keep(item => !item.isComplete)
    | ShowAll => list
    }
  },
})

type stats = {
  totalNum: int,
  totalCompletedNum: int,
  totalUncompletedNum: int,
  percentCompleted: float,
}

let todoListStatsState = Recoil.selector({
  key: "todoListStatsState",
  get: ({get}) => {
    let todoList = get(filteredTodoListState)
    let totalNum = todoList->Array.length
    let totalCompletedNum = todoList->Array.keep(item => item.isComplete)->Array.length
    let totalUncompletedNum = totalNum - totalCompletedNum
    let percentCompleted =
      totalNum === 0 ? 0.0 : totalCompletedNum->Float.fromInt /. totalNum->Float.fromInt

    {
      totalNum: totalNum,
      totalCompletedNum: totalCompletedNum,
      totalUncompletedNum: totalUncompletedNum,
      percentCompleted: percentCompleted,
    }
  },
})

module TodoItemCreator = {
  @react.component
  let make = () => {
    let (inputValue, setInputValue) = React.useState(() => "")
    let setTodoList = Recoil.useSetRecoilState(todoListState)

    let addItem = () => {
      setInputValue(_ => "")
      setTodoList(oldTodoList =>
        oldTodoList->Array.concat([{id: getId(), text: inputValue, isComplete: false}])
      )
    }

    let onChange = event => {
      let value = (event->ReactEvent.Form.target)["value"]
      setInputValue(_ => value)
    }

    <div>
      <input
        type_="text"
        value=inputValue
        onChange
        onKeyDown={event =>
          if event->ReactEvent.Keyboard.key == "Enter" {
            addItem()
          }}
      />
      <button onClick={_ => addItem()}> {"Add"->React.string} </button>
    </div>
  }
}

module TodoItem = {
  let replaceItemAtIndex = (array, index, value) =>
    Array.concatMany([
      array->Array.slice(~offset=0, ~len=index),
      [value],
      array->Array.sliceToEnd(index + 1),
    ])

  let removeItemAtIndex = (array, index) =>
    Array.concatMany([
      array->Array.slice(~offset=0, ~len=index),
      array->Array.sliceToEnd(index + 1),
    ])

  @react.component
  let make = (~item) => {
    let (todoList, setTodoList) = Recoil.useRecoilState(todoListState)
    let index = todoList->Array.getIndexBy(listItem => listItem === item)

    let editItemText = event =>
      switch index {
      | Some(index) =>
        let value = (event->ReactEvent.Form.target)["value"]
        let newList = replaceItemAtIndex(todoList, index, {...item, text: value})
        setTodoList(_ => newList)
      | None => ()
      }

    let toggleItemCompletion = _ =>
      switch index {
      | Some(index) =>
        let newList = replaceItemAtIndex(todoList, index, {...item, isComplete: !item.isComplete})
        setTodoList(_ => newList)
      | None => ()
      }

    let deleteItem = _ =>
      switch index {
      | Some(index) =>
        let newList = removeItemAtIndex(todoList, index)
        setTodoList(_ => newList)
      | None => ()
      }

    <div>
      <input type_="text" value=item.text onChange=editItemText />
      <input type_="checkbox" checked=item.isComplete onChange=toggleItemCompletion />
      <button onClick=deleteItem> {"X"->React.string} </button>
    </div>
  }
}

module TodoListFilters = {
  @react.component
  let make = () => {
    let (filter, setFilter) = Recoil.useRecoilState(todoListFilterState)

    let updateFilter = event => {
      let value = (event->ReactEvent.Form.target)["value"]
      switch value {
      | "Show All" => setFilter(_ => ShowAll)
      | "Show Completed" => setFilter(_ => ShowCompleted)
      | "Show Uncompleted" => setFilter(_ => ShowUncompleted)
      | _ => ()
      }
    }

    <>
      {"Filter: "->React.string}
      <select
        value={switch filter {
        | ShowAll => "Show All"
        | ShowCompleted => "Show Completed"
        | ShowUncompleted => "Show Uncompleted"
        }}
        onChange=updateFilter>
        <option value="Show All"> {"All"->React.string} </option>
        <option value="Show Completed"> {"Completed"->React.string} </option>
        <option value="Show Uncompleted"> {"Uncompleted"->React.string} </option>
      </select>
    </>
  }
}

module TodoListStats = {
  @react.component
  let make = () => {
    let {
      totalNum,
      totalCompletedNum,
      totalUncompletedNum,
      percentCompleted,
    } = Recoil.useRecoilValue(todoListStatsState)

    let formattedPercentCompleted = Js.Math.round(percentCompleted *. 100.0)

    <ul>
      <li> {j`Total items: $totalNum`->React.string} </li>
      <li> {j`Items completed: $totalCompletedNum`->React.string} </li>
      <li> {j`Items not completed: $totalUncompletedNum`->React.string} </li>
      <li> {j`Percent completed: $(formattedPercentCompleted)%`->React.string} </li>
    </ul>
  }
}

module TodoList = {
  @react.component
  let make = () => {
    let todoList = Recoil.useRecoilValue(filteredTodoListState)
    <>
      <TodoListStats />
      <TodoListFilters />
      <TodoItemCreator />
      {todoList
      ->Array.map(({id} as todoItem) => <TodoItem item=todoItem key=j`$id` />)
      ->React.array}
    </>
  }
}

ReactDOMRe.renderToElementWithId(<Recoil.RecoilRoot> <TodoList /> </Recoil.RecoilRoot>, "root")
