# Listen Router

easy custom port router for jester.

```
import listenrouter

listenRouter(5555):
  get "/":
    resp  "<p>hello nim</p>
```

convert ...

```
import jester
router templateRouter:
  get "/":
    resp  "<p>hello nim</p>
let settings = newSettings(port=Port(5555))
var j = initJester(templateRouter, settings=settings)
j.serve()
```

## License

MIT license.

