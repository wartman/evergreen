package eg;

import pine.*;

using Kit;

class DropdownPanel extends AutoComponent {
  final onHide:()->Void;
  final gap:Int;
  final attachment:PositionedAttachment;
  final child:Child;

  function build() {
    #if (js && !nodejs)
    var document = js.Browser.document;
    
    onMount(() -> {
      document.addEventListener('keydown', onKeyDown);
      document.addEventListener('click', hide);
      maybeFocusFirst();
    });
    addDisposable(() -> {
      document.removeEventListener('keydown', onKeyDown);
      document.removeEventListener('click', hide);
      FocusContext.from(this).returnFocus();
    });
    #end

    return new Popover({
      getTarget: () -> findAncestorOfType(Dropdown)
        .orThrow('No Dropdown')
        .findChildOfType(DropdownToggle, true)
        .orThrow('No dropdown toggle')
        .getObject(),
      gap: gap,
      attachment: attachment,
      child: child
    });
  }
  
  #if (js && !nodejs)
  var current:Null<DropdownItem> = null;

  function hide(e:js.html.Event) {
    e.stopPropagation();
    e.preventDefault();
    onHide();
  }

  function getNextFocusedChild(offset:Int):Maybe<Component> {
    var items = queryChildrenOfType(DropdownItem, true);
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
        FocusContext.from(this).focus(el);
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
    if (isComponentBuilding() || isComponentDisposed()) return;

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
  #end
}
