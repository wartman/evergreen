package eg;

import pine.*;
import eg.Layer;

using Nuke;
using pine.Cast;

class LayerContainer extends HookComponent {
  @prop public final hideOnEscape:Bool;

  public function createElement():Element {
    return new LayerContainerElement(this);
  }
}

@component(LayerContainer)
class LayerContainerElement extends HookElement {
  function onUpdate(previousComponent:Null<Component>) {
    #if (js && !nodejs)
    if (previousComponent != null) return;
    var el = getTargetElement();
    el.ownerDocument.addEventListener('keydown', onKeyDown);
    FocusContext.from(this).focus(el);
    #end
  }

  function performDispose() {
    #if (js && !nodejs)
    var el = getTargetElement();
    el.ownerDocument.removeEventListener('keydown', onKeyDown);
    FocusContext.from(this).returnFocus();
    #end
  }

  #if (js && !nodejs)
  inline function getTargetElement():js.html.Element {
    return switch LayerTarget.maybeFrom(this) {
      case Some(element):
        element.getObject().as(js.html.Element);
      case None: 
        Portal.getObjectMaybeInPortal(this).as(js.html.Element);
    }
  }

  function hide(e:js.html.Event) { 
    e.preventDefault();
    LayerContext.from(this).hide();
  }

  function onKeyDown(event:js.html.KeyboardEvent) {
    switch event.key {
      case 'Escape' if (layerContainer.hideOnEscape): hide(event);
      default:
    }
  }
  #end
}
