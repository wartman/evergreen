package eg;

import js.html.Event;
import js.html.KeyboardEvent;
import pine.*;

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

function useKeyPressEvents<T:Component>(
  context:Context,
  handle:(e:KeyboardEvent, element:ElementOf<T>)->Void
) {
  var hook = Hook.from(context);
  var event = hook.useData(
    () -> { onKeyDown: e -> handle(e, context) }, 
    event -> {
      var el:js.html.Element = context.getObject();
      el.ownerDocument.removeEventListener('keydown', event.onKeyDown);
    }
  );
  hook.useInit(() -> {
    var el:js.html.Element = context.getObject();
    el.ownerDocument.addEventListener('keydown', event.onKeyDown);
  });
}

function useGlobalClickEvent<T:Component>(
  context:Context,
  handle:(e:Event, element:ElementOf<T>)->Void
) {
  var hook = Hook.from(context);
  var event = hook.useData(
    () -> { onClick: e -> handle(e, context) }, 
    event -> {
      var el:js.html.Element = context.getObject();
      el.ownerDocument.removeEventListener('click', event.onClick);
    }
  );
  hook.useInit(() -> {
    var el:js.html.Element = context.getObject();
    el.ownerDocument.addEventListener('click', event.onClick);
  });
}
