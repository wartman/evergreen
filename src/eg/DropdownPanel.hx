package eg;

import pine.*;

using Kit;

class DropdownPanel extends AutoComponent {
  public final onHide:()->Void;
  final attachment:PositionedAttachment;
  final child:Child;

  function build() {
    #if (js && !nodejs)
    var controller = createController(this);
    var document = js.Browser.document;
    
    onMount(() -> {
      document.addEventListener('keydown', controller.onKeyDown);
      document.addEventListener('click', controller.hide);
      controller.maybeFocusFirst();
    });
    onCleanup(() -> {
      document.removeEventListener('keydown', controller.onKeyDown);
      document.removeEventListener('click', controller.hide);
      FocusContext.from(this).returnFocus();
    });
    #end

    return new Popover({
      getTarget: () -> findAncestorOfType(Dropdown)
        .orThrow('No Dropdown')
        .findChildOfType(DropdownToggle, true)
        .orThrow('No dropdown toggle')
        .getObject(),
      attachment: attachment,
      child: child
    });
  }
}

#if (js && !nodejs)
private function createController(panel:DropdownPanel):{
  hide:(e:js.html.Event)->Void,
  onKeyDown:(e:js.html.KeyboardEvent)->Void,
  maybeFocusFirst:()->Void
} {
  var current:Null<DropdownItem> = null;

  function hide(e:js.html.Event) {
    e.stopPropagation();
    e.preventDefault();
    panel.onHide();
  }

  function getNextFocusedChild(offset:Int):Maybe<Component> {
    var items = panel.queryChildrenOfType(DropdownItem, true);
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
        FocusContext.from(panel).focus(el);
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
    // if (panel.getStatus() == Building || panel.getStatus() == Disposed) return;

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
#end
