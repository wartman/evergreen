package eg;

import haxe.ds.Option;
import pine.*;
import pine.Portal;

using pine.Cast;

class DropdownContainer extends HookComponent {
  @prop public final onHide:()->Void;

  public function createElement():Element {
    return new DropdownContainerElement(this);
  }
}

@component(DropdownContainer)
class DropdownContainerElement extends HookElement {
  function onUpdate(previousComponent:Null<Component>) {
    #if (js && !nodejs)
    if (previousComponent != null) return;

    var el = getPossiblePortalElement();

    el.addEventListener('click', syncClicksWithActiveElement);
    el.ownerDocument.addEventListener('click', hide);
    el.ownerDocument.addEventListener('keydown', onKeyDown);

    maybeFocusFirst();
    #end
  }

  function performDispose() {
    #if (js && !nodejs)
    var el = getPossiblePortalElement();

    el.removeEventListener('click', syncClicksWithActiveElement);
    el.ownerDocument.removeEventListener('click', hide);
    el.ownerDocument.removeEventListener('keydown', onKeyDown);

    FocusContext.from(this).returnFocus();
    #end
  }

  #if (js && !nodejs)
  function hide(e:js.html.Event) { 
    e.stopPropagation();
    e.preventDefault();
    dropdownContainer.onHide();
  }

  function syncClicksWithActiveElement(event:js.html.Event) {
    var target = event.target.as(js.html.Element);
    switch getMenu() {
      case Some(el): switch el.queryFirstChild(child -> child.getObject() == target) {
        case Some(el):
          current = el;
        case None:
      }
      case None:
    }
  }

  function onKeyDown(event:js.html.KeyboardEvent) {
    if (status == Building || status == Disposed) return;

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

  inline function getPossiblePortalElement() {
    var el:js.html.Element = Portal.getObjectMaybeInPortal(this);
    return el;
  }

  function maybeFocusFirst() {
    switch getNextFocusedChild(1) {
      case Some(item): 
        var el = item.getObject().as(js.html.Element);
        FocusContext.from(this).focus(el);
      case None:
    }
  }

  function focusNext(e:js.html.KeyboardEvent, hideIfLast:Bool = false) {
    e.preventDefault();
    switch getNextFocusedChild(1) {
      case Some(item): 
        item.getObject().as(js.html.Element).focus();
      case None if (hideIfLast): 
        hide(e);
      case None:
    }
  }

  function focusPrevious(e:js.html.KeyboardEvent, hideIfFirst:Bool = false) {
    e.preventDefault();
    switch getNextFocusedChild(-1) {
      case Some(item): 
        item.getObject().as(js.html.Element).focus();
      case None if (hideIfFirst): 
        hide(e);
      case None:
    }
  }

  var current:Null<Element> = null;

  function getNextFocusedChild(offset:Int):Option<Element> {
    switch getMenu() {
      case Some(menu): switch menu.queryChildren(child -> {
        return child.getComponent().getComponentType() == DropdownItem.componentType;
      }) {
        case Some(items):
          var index = Math.ceil(items.indexOf(current) + offset);
          var item = items[index];
          if (item != null) {
            current = item;
            return Some(current);
          }
        case None:
      }
      case None:
    }

    return None;
  }

  // @todo:
  // The way Portals work breaks a lot of stuff, as `visitChildren` will
  // return their placeholder children, not the actual content. We 
  // should consider a way to change this so we don't need wacky
  // stuff like the following method.
  function getMenu():Option<Element> {
    var query = (target:Element) -> target
      .queryFirstChild(el -> el.getComponent().getComponentType() == DropdownItem.componentType);
    
    return switch queryFirstChild(child -> child is PortalElement) {
      case Some(portal): switch portal.as(PortalElement).getPortalRoot() {
        case Some(el): query(el);
        default: query(this);
      }
      default:
        query(this);
    }
  }
  #end
}
