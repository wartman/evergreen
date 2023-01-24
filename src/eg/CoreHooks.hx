package eg;

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
  function onKeyDown(e:KeyboardEvent) {
    handle(e, context);
  }

  var hook = Hook.from(context);

  hook.useNext(() -> {
    var el:js.html.Element = context.getObject();
    el.ownerDocument.addEventListener('keydown', onKeyDown);
  });

  hook.useCleanup(() -> {
    var el:js.html.Element = context.getObject();
    el.ownerDocument.removeEventListener('keydown', onKeyDown);
  });
}
