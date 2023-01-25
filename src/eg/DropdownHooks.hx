package eg;

import haxe.ds.Option;
import pine.*;

using pine.core.OptionTools;

function useDropdown(element:ElementOf<DropdownPanel>) {
  var hook = Hook.from(element);
  var controller = hook.useData(() -> createController(element));
  hook.useElement(element -> {
    var cancelInit = element.events.afterInit.add((_, _) -> {
      var el:js.html.Element = element.getObject();
  
      // el.addEventListener('click', syncClicksWithActiveElement);
      el.ownerDocument.addEventListener('click', controller.hide);
      el.ownerDocument.addEventListener('keydown', controller.onKeyDown);
  
      controller.maybeFocusFirst();
    });
    () -> {
      cancelInit();
      var el:js.html.Element = element.getObject();
      // el.removeEventListener('click', syncClicksWithActiveElement);
      el.ownerDocument.removeEventListener('click', controller.hide);
      el.ownerDocument.removeEventListener('keydown', controller.onKeyDown);
      FocusContext.from(element).returnFocus();
    }
  });
}

function createController(element:ElementOf<DropdownPanel>):{
  hide:(e:js.html.Event)->Void,
  onKeyDown:(e:js.html.KeyboardEvent)->Void,
  maybeFocusFirst:()->Void
} {
  var current:Null<Element> = null;

  function hide(e:js.html.Event) {
    e.stopPropagation();
    e.preventDefault();
    element.component.onHide();
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

  return {
    hide: hide,
    onKeyDown: onKeyDown,
    maybeFocusFirst: maybeFocusFirst
  };
}
