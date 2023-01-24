package eg;

import pine.CoreHooks;
import js.html.KeyboardEvent;
import pine.*;

function takeFocus<T:Component>(
  hook:Hook<T>,
  getTargetObject:(element:Element)->js.html.Element
) {
  useElement(hook, element -> {
    var cancel = element.events.afterInit.add((element, _) -> {
      FocusContext.from(element).focus(getTargetObject(element));
    });
    () -> {
      cancel();
      FocusContext.from(element).returnFocus();
    }
  });
}

function watchKeyPressEvents<T:Component>(
  hook:Hook<T>,
  handle:(e:KeyboardEvent, element:ElementOf<T>)->Void
) {
  useElement(hook, element -> {
    function onKeyDown(e:KeyboardEvent) {
      handle(e, element);
    }

    useNext(hook, () -> {
      var el:js.html.Element = element.getObject();
      el.ownerDocument.addEventListener('keydown', onKeyDown);
    });

    () -> {
      var el:js.html.Element = element.getObject();
      el.ownerDocument.removeEventListener('keydown', onKeyDown);
    };
  });
}
