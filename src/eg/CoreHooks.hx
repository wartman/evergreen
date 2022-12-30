package eg;

import js.html.KeyboardEvent;
import pine.*;

function takeFocus<T:Component>(getTargetObject:(element:Element)->js.html.Element):Hook<T> {
  return element -> {
    element.watchLifecycle({
      afterInit: (element, _) -> {
        FocusContext.from(element).focus(getTargetObject(element));
      },
      beforeDispose: element -> {
        FocusContext.from(element).returnFocus();
      }
    });
  }
}

function watchKeyPressEvents<T:Component>(handle:(e:KeyboardEvent, element:ElementOf<T>)->Void):Hook<T> {
  return element -> {
    function onKeyDown(e:KeyboardEvent) {
      handle(e, element);
    }

    element.watchLifecycle({
      afterInit: (element, _) -> {
        var el:js.html.Element = element.getObject();
        el.ownerDocument.addEventListener('keydown', onKeyDown);
      },
      beforeDispose: element -> {
        var el:js.html.Element = element.getObject();
        el.ownerDocument.removeEventListener('keydown', onKeyDown);
      }
    });
  }
}
