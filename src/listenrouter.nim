import jester
import macros, os

export jester

macro listenRouter*(prmPort: int, stmt: untyped): untyped =
  template makeRouter(prmPort: int, stmt: untyped): untyped =
    router templateRouter:
      stmt
    let settings = newSettings(
      port = Port(prmPort),
      staticDir = getCurrentDir() / "public"
    )
    var j = initJester(templateRouter, settings = settings)
    j.serve()
  getAST(makeRouter(prmPort, stmt[0]))


when isMainModule:
  listenRouter(5555):
    get "/":
      resp "<p>hello, world.</p>"

