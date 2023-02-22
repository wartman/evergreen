package eg;

import pine.*;

class ScrollLocked extends AutoComponent {
  final child:Child;

  function render(context:Context) {
    #if (js && !nodejs)
    return new Proxy<ScrollLocked>({
      target: context,
      setup: element -> {
        element.onInit(() -> {
          var body = js.Browser.document.body;
          var beforeWidth = body.offsetWidth;
          // @todo: This method is fragile if we ever want to do something else
          // with the `style` tag OR if more than one Layer is active.
          body.setAttribute('style', 'overflow:hidden;');
          var afterWidth = body.offsetWidth;
          var offset = afterWidth - beforeWidth;
          if (offset > 0) {
            body.setAttribute('style', 'overflow:hidden;padding-right:${offset}px');
          }
          return () -> body.removeAttribute('style');
        });
      },
      child: child
    });
    #else
    return child;
    #end
  }
}