package eg;

import js.html.KeyboardEvent;
import pine.*;

function takeFocus<T:Component>(getTargetObject:(element:Element)->js.html.Element):Hook<T> {
  return element -> {
    element.addLifecycle({
      afterInit: element -> {
        FocusContext.from(element).focus(getTargetObject(element));
      },
      onDispose: element -> {
        FocusContext.from(element).returnFocus();
      }
    });
  }
}

function watchKeypressEvents<T:Component>(handle:(e:KeyboardEvent, element:ElementOf<T>)->Void):Hook<T> {
  return element -> {
    function onKeyDown(e:KeyboardEvent) {
      handle(e, element);
    }

    element.addLifecycle({
      afterInit: element -> {
        var el:js.html.Element = element.getObject();
        el.ownerDocument.addEventListener('keydown', onKeyDown);
      },
      onDispose: element -> {
        var el:js.html.Element = element.getObject();
        el.ownerDocument.removeEventListener('keydown', onKeyDown);
      }
    });
  }
}
