package eg.internal;

private final hasRaf:Bool = js.Syntax.code("typeof window != 'undefined' && 'requestAnimationFrame' in window");

function defer(exec:() -> Void) {
  if (hasRaf)
    js.Syntax.code('window.requestAnimationFrame({0})', time -> {
      js.Browser.window.requestAnimationFrame(_ -> exec());
    }); 
  else
    haxe.Timer.delay(() -> exec(), 10);
}

function lockBody() {
  #if (js && !nodejs)
    var body = getBody();
    var beforeWidth = body.offsetWidth;
    body.setAttribute('style', 'overflow:hidden;');
    var afterWidth = body.offsetWidth;
    var offset = afterWidth - beforeWidth;
    if (offset > 0) {
      body.setAttribute('style', 'overflow:hidden;padding-right:${offset}px');
    }
  #end
}

function unlockBody() {
  #if (js && !nodejs)
    getBody().removeAttribute('style');
  #end
}

#if (js && !nodejs)
  function getBody() {
    return js.Browser.document.body;
  }
#else
  function getBody() {
    return null;
  }
#end
