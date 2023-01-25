package eg;

import js.Browser;
import js.html.Event;
import js.html.KeyboardEvent;
import pine.*;

// @todo: Make this module isomorphic

function useFocus<T:Component>(
  context:Context,
  getTargetObject:(element:Element)->js.html.Element
) {
  Hook.from(context).useElement((element:ElementOf<T>) -> {
    var cancel = element.events.afterInit.add((element, _) -> {
      FocusContext.from(element).focus(getTargetObject(element));
    });
    () -> {
      cancel();
      FocusContext.from(element).returnFocus();
    }
  });
}

function useWindowEvent<T:Component, E:Event>(
  context:Context,
  name:String,
  handle:(e:E, element:ElementOf<T>)->Void
) {
  var hook = Hook.from(context);
  var event = hook.useData(
    () -> { handler: e -> handle(e, context) }, 
    event -> {
      Browser.window.removeEventListener(name, event.handler);
    }
  );
  hook.useInit(() -> {
    Browser.window.addEventListener(name, event.handler);
  });
}

function useDocumentEvent<T:Component, E:Event>(
  context:Context,
  name:String,
  handle:(e:E, element:ElementOf<T>)->Void
) {
  var hook = Hook.from(context);
  var event = hook.useData(
    () -> { handler: e -> handle(e, context) }, 
    event -> {
      var el:js.html.Element = context.getObject();
      el.ownerDocument.removeEventListener(name, event.handler);
    }
  );
  hook.useInit(() -> {
    var el:js.html.Element = context.getObject();
    el.ownerDocument.addEventListener(name, event.handler);
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
