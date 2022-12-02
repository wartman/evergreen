package eg;

import js.html.KeyboardEvent;
import pine.*;

class KeyboardController<T:Component> implements Controller<T> {
  final handle:(e:KeyboardEvent, element:ElementOf<T>)->Void;

  public function new(handle) {
    this.handle = handle;
  }

  public function register(element:ElementOf<T>) {
    function onKeyDown(e:KeyboardEvent) {
      handle(e, element);
    }

    element.addHook({
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
  
  public function dispose() {}
}
