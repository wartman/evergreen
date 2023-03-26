package eg;

import pine.*;
import haxe.ds.Option;

class DropdownPanel extends AutoComponent {
  public final onHide:()->Void;
  final attachment:PositionedAttachment;
  final child:Child;

  function render(context:Context) {
    var popover = new Popover({
      getTarget: () -> context
        .queryAncestors()
        .ofType(Dropdown)
        .orThrow('No Dropdown')
        .queryChildren()
        .findOfType(DropdownToggle, true)
        .orThrow('No dropdown toggle')
        .getObject(),
      attachment: attachment,
      child: child
    });

    #if (js && !nodejs)
    return new Setup<DropdownPanel>({
      target: context,
      setup: element -> {
        var controller = createController(context);
        var document = js.Browser.document;
        
        document.addEventListener('keydown', controller.onKeyDown);
        document.addEventListener('click', controller.hide);

        element.onInit(() -> {
          controller.maybeFocusFirst();
          return () -> {
            document.removeEventListener('keydown', controller.onKeyDown);
            document.removeEventListener('click', controller.hide);
            FocusContext.from(context).returnFocus();
          }
        });
      },
      child: popover
    });
    #else
    return popover;
    #end
  }
}

#if (js && !nodejs)
private function createController(element:ElementOf<DropdownPanel>):{
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
#end
