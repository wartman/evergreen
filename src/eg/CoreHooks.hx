package eg;

import pine.*;
import pine.html.HtmlEvents;

using pine.Hooks;

function useFocus<T:Component>(
  context:Context,
  getTargetObject:(element:ElementOf<T>)->Dynamic
) {
  #if (js && !nodejs)
  context.useInit(() -> {
    FocusContext.from(context).focus(getTargetObject(context));
    return () -> FocusContext.from(context).returnFocus();
  });
  #end
}

function useWindowEvent<T:Component, E:Event>(
  context:Context,
  name:String,
  handle:(e:E, element:ElementOf<T>)->Void
) {
  #if (js && !nodejs)
  context.useInit(() -> {
    var handler = e -> handle(e, context);
    var window = js.Browser.window;
    window.addEventListener(name, handler);
    return () -> window.removeEventListener(name, handler);
  });
  #end
}

function useDocumentEvent<T:Component, E:Event>(
  context:Context,
  name:String,
  handle:(e:E, element:ElementOf<T>)->Void
) {
  #if (js && !nodejs)
  context.useInit(() -> {
    var handler = e -> handle(e, context);
    var el:js.html.Element = context.getObject();
    var document = el.ownerDocument;
    document.addEventListener(name, handler);
    return () -> document.removeEventListener(name, handler);
  });
  #end
}

inline function useKeyPressEvents<T:Component>(
  context:Context,
  handle:(e:js.html.KeyboardEvent, element:ElementOf<T>)->Void
) {
  useDocumentEvent(context, 'keydown', handle);
}

inline function useGlobalClickEvent<T:Component>(
  context:Context,
  handle:(e:Event, element:ElementOf<T>)->Void
) {
  useDocumentEvent(context, 'click', handle);
}

function useLockedDocumentBody(context:Context) {
  #if (js && !nodejs)
  context.useInit(() -> {
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
  #end
}
