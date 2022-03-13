import listenRouter
import htmlgen

listenRouter(5002):
  get "/":
    resp """
<p>root</p>
<ul>
<li><a href="/test">test</a></li>
<li><a href="/test/xyzzy">test xyzzy</a></li>
</ul>
<form method="post" action="/regist">
<input type="text" name="txt" length="40"> <input type="submit">
</form>
"""
  get "/test":
    resp "test" & " " & a(href = "/", "top")
  get "/test/@id":
    resp "id=" & @"id" & " " & a(href = "/", "top")
  post "/regist":
    resp "regist=" & request.params["txt"] & " " & a(href = "/", "top")

