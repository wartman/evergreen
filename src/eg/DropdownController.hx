package eg;

import haxe.ds.Option;
import pine.*;

using pine.core.OptionTools;

@:access(pine)
class DropdownController {
  final element:ElementOf<DropdownPanel>;
  var current:Null<Element> = null;

  public function new(element) {
    this.element = element;
    
    element.watchLifecycle({
      afterInit: (element, _) -> {
        var el:js.html.Element = element.getObject();

        // el.addEventListener('click', syncClicksWithActiveElement);
        el.ownerDocument.addEventListener('click', hide);
        el.ownerDocument.addEventListener('keydown', onKeyDown);

        maybeFocusFirst();
      },
      beforeDispose: element -> {
        var el:js.html.Element = element.getObject();

        // el.removeEventListener('click', syncClicksWithActiveElement);
        el.ownerDocument.removeEventListener('click', hide);
        el.ownerDocument.removeEventListener('keydown', onKeyDown);

        FocusContext.from(element).returnFocus();
      }
    });
  }

  function hide(e:js.html.Event) {
    e.stopPropagation();
    e.preventDefault();
    element.component.onHide();
  }

  function onKeyDown(event:js.html.KeyboardEvent) {
    if (element.status == Building || element.status == Disposed) return;

    switch event.key {
      case 'Escape': 
        hide(event);
      case 'ArrowUp':
        focusPrevious(event);
      case 'ArrowDown':
        focusNext(event);
      case 'Tab' if (event.getModifierState('Shift')):
        focusPrevious(event, true);
      case 'Tab':
        focusNext(event, true);
      case 'Home': // ??
        maybeFocusFirst();
      default:
    }
  }

  function maybeFocusFirst() {
    switch getNextFocusedChild(1) {
      case Some(item):
        var el:js.html.Element = item.getObject();
        FocusContext.from(element).focus(el);
      case None:
    }
  }

  function focusNext(e:js.html.KeyboardEvent, hideIfLast:Bool = false) {
    e.preventDefault();
    switch getNextFocusedChild(1) {
      case Some(item): 
        (item.getObject():js.html.Element).focus();
      case None if (hideIfLast): 
        hide(e);
      case None:
    }
  }

  function focusPrevious(e:js.html.KeyboardEvent, hideIfFirst:Bool = false) {
    e.preventDefault();
    switch getNextFocusedChild(-1) {
      case Some(item): 
        (item.getObject():js.html.Element).focus();
      case None if (hideIfFirst): 
        hide(e);
      case None:
    }
  }

  function getNextFocusedChild(offset:Int):Option<Element> {
    var items = element.queryChildren().filterOfType(DropdownItem, true);
    var index = Math.ceil(items.indexOf(current) + offset);
    var item = items[index];
    if (item != null) {
      current = item;
      return Some(current);
    }

    return None;
  }
}
