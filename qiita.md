# Jester で少し簡単にポート指定できるマクロの紹介

## ダウンロード
ソースは下記にあげてあります。

https://github.com/MoonSeaSkyFish/listenRouter

## 使い方

```nim
import listenRouter

listenRouter(5555):
  get "/":
    resp "hello"
```

これで、コンパイルして起動すると、localhost:5555 でアクセスできます。

下記のように書くより、ほんの少し楽できます。ほんの少し！ 減ったのわずか三行だし……

```nim
import jester

router myRouter:
  get "/":
    resp "hello"

let settings = newSettings(port=Port(5555))
var j = initJester(myRouter, settings=settings)
j.serve()
```

## 中身の解説みたいなもの

中身は、短く下記のとおり。


```nim
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
```

ASTツリーを簡単に記述しました。


## 間違え


以下、間違えたので削除ですが、どう間違えたのかを記録に残しておきます。いないと思いますが、似たような間違えをする人がいるかもしれないので。

```nim
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
```

staticDir = getCurrentDir() / "public" の部分は既定値のままですが、public_htmlがいいんだ！とかこだわりのある人は変更してください。毎回、setStaticDirせんでも楽できるようになります。

あと、getASTが便利そうです。引数は、マクロかテンプレート。

stmt[0] は、stmtの外側はいらないので。つまり……

```nim
echo stmt.treeRepr
結果
StmtList
  Command
    Ident "get"
    StrLit "/"
    StmtList
      Command
        Ident "resp"
        StrLit "hello"
\```

この、StmtListの部分はいらないため、stmt[0]としています。→これだと、最初のgetしか処理しません。

どーてもいいですが、template makeRouterの引数、prmPortは、portとしたら、はまりました。冷静になって考えてみれば、テンプレートなのだから当たり前なのですが……

```nim
  port = Port(port),
```

引数をportにすると、この左辺のportも置換するんですから、おかしくなりますよねー。

このマクロをたたき台にして、いろいろ、遊んでくれたら幸いです。



