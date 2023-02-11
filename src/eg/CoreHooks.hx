package eg;

import js.Browser;
import js.html.Event;
import js.html.KeyboardEvent;
import pine.*;

using pine.Hooks;

// @todo: Make this module isomorphic

function useFocus<T:Component>(
  context:Context,
  getTargetObject:(element:ElementOf<T>)->js.html.Element
) {
  context.useInit(() -> {
    FocusContext.from(context).focus(getTargetObject(context));
    return () -> FocusContext.from(context).returnFocus();
  });
}

function useWindowEvent<T:Component, E:Event>(
  context:Context,
  name:String,
  handle:(e:E, element:ElementOf<T>)->Void
) {
  context.useInit(() -> {
    var handler = e -> handle(e, context);
    Browser.window.addEventListener(name, handler);
    return () -> Browser.window.removeEventListener(name, handler);
  });
}

function useDocumentEvent<T:Component, E:Event>(
  context:Context,
  name:String,
  handle:(e:E, element:ElementOf<T>)->Void
) {
  context.useInit(() -> {
    var handler = e -> handle(e, context);
    var el:js.html.Element = context.getObject();
    var document = el.ownerDocument;
    document.addEventListener(name, handler);
    return () -> document.removeEventListener(name, handler);
  });
}

inline function useKeyPressEvents<T:Component>(
  context:Context,
  handle:(e:KeyboardEvent, element:ElementOf<T>)->Void
) {
  useDocumentEvent(context, 'keydown', handle);
}

inline function useGlobalClickEvent<T:Component>(
  context:Context,
  handle:(e:Event, element:ElementOf<T>)->Void
) {
  useDocumentEvent(context, 'click', handle);
}
