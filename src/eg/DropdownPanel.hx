package eg;

import pine.*;
import haxe.ds.Option;

using pine.core.OptionTools;
using pine.Hooks;
using eg.CoreHooks;

class DropdownPanel extends AutoComponent {
  public final onHide:()->Void;
  final attachment:PositionedAttachment;
  final child:Child;

  function render(context:Context) {
    #if (js && !nodejs)
    // var hook = Hook.from(context);
    var controller = context.useMemo(() -> createController(context));
    context.useKeyPressEvents((e, _) -> controller.onKeyDown(e));
    context.useGlobalClickEvent((e, _) -> controller.hide(e));
    context.useInit(() -> {
      controller.maybeFocusFirst();
      return () -> FocusContext.from(context).returnFocus();
    });
    #end

    return new Popover({
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
