package eg;

import haxe.ds.Option;
import pine.*;

using pine.core.OptionTools;

// @todo: I don't think this is getting positioned right.
@:access(pine)
class DropdownController implements Controller<DropdownContainer> {
  var el:Option<ElementOf<DropdownContainer>> = None;

  public function new() {}

  public function register(element:ElementOf<DropdownContainer>) {
    el = Some(element);
    element.addHook({
      afterInit: element -> {
        var el:js.html.Element = element.getObject();

        // el.addEventListener('click', syncClicksWithActiveElement);
        el.ownerDocument.addEventListener('click', hide);
        el.ownerDocument.addEventListener('keydown', onKeyDown);

        maybeFocusFirst();
      },
      onDispose: element -> {
        var el:js.html.Element = element.getObject();

        // el.removeEventListener('click', syncClicksWithActiveElement);
        el.ownerDocument.removeEventListener('click', hide);
        el.ownerDocument.removeEventListener('keydown', onKeyDown);

        FocusContext.from(element).returnFocus();
      }
    });
  }

  public function dispose() {
    el = None;
  }

  function hide(e:js.html.Event) {
    var element = switch el {
      case Some(el): el;
      case None: return;
    }

    e.stopPropagation();
    e.preventDefault();
    element.getComponent().onHide();
  }

  function onKeyDown(event:js.html.KeyboardEvent) {
    var element = switch el {
      case Some(el): el;
      case None: return;
    }

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
    var element = switch el {
      case Some(el): el;
      case None: return;
    }

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

  var current:Null<Element> = null;

  function getNextFocusedChild(offset:Int):Option<Element> {
    var menu = switch el {
      case Some(el): el;
      case None: return None;
    }
    var items = menu.queryChildren().filterOfType(DropdownItem, true);
    var index = Math.ceil(items.indexOf(current) + offset);
    var item = items[index];
    if (item != null) {
      current = item;
      return Some(current);
    }

    return None;
  }
}
