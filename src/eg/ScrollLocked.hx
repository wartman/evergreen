package eg;

import pine.*;

class ScrollLocked extends AutoComponent {
  final child:Child;

  function build() {
    #if (js && !nodejs)
    var body = js.Browser.document.body;
    onMount(() -> {
      var beforeWidth = body.offsetWidth;
      // @todo: This method is fragile if we ever want to do something else
      // with the `style` tag OR if more than one Layer is active.
      body.setAttribute('style', 'overflow:hidden;');
      var afterWidth = body.offsetWidth;
      var offset = afterWidth - beforeWidth;
      if (offset > 0) {
        body.style.overflow = 'hidden';
        body.style.paddingRight = '${offset}px';
      }
    });
    addDisposable(() -> {
      body.style.overflow = null;
      body.style.paddingRight = null;
    });
    #end
    return child;
  }
}
