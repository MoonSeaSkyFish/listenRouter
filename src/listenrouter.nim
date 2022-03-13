import macros, os
import jester
import jester/private/utils
export jester

macro makeRoute(cfg: Settings, stmt: untyped): untyped =
  let stmt = newStmtList(
    nnkCommand.newTree(
      newIdentNode("router"),
      newIdentNode("listenMainRouter"),
      stmt
    )
  )
  quote do:
    `stmt`
    var j = initJester(listenMainRouter, settings = `cfg`)
    j.serve()

macro listenRouter*(cfg: Settings, stmt: untyped): untyped =
  getAST(makeRoute(cfg, stmt))

macro listenRouter*(port: int, stmt: untyped): untyped =
  let cfg = quote do:
    newSettings(port = Port(`port`),
                 staticDir = getCurrentDir() / "public")
  getAST(makeRoute(cfg, stmt))

