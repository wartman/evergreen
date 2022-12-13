package eg.internal;

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

function getBody() {
  #if (js && !nodejs)
  return js.Browser.document.body;
  #else
  return null;
  #end
}
