package eg;

import pine.*;
import pine.html.*;

using Nuke;

class Modal extends AutoComponent {
  final styles:ClassName = null;
  final layerStyles:ClassName = null;
  final onHide:()->Void;
  final children:Children;
  final hideOnEscape:Bool = true;
  final lockScroll:Bool = true;

  public function render(context:Context):Component {
    var portal = new Portal({
      target: PortalContext.from(context).getTarget(),
      child: new Layer({
        styles: layerStyles,
        hideOnEscape: hideOnEscape,
        onHide: onHide,
        child: new Html<'div'>({
          className: ClassName.ofArray([
            'eg-modal-container',
            styles
          ]),
          onclick: e -> e.stopPropagation(),
          ariaModal: 'true',
          tabIndex: -1,
          role: 'dialog',
          children: children
        })
      })
    });

    if (!lockScroll) return portal;

    return new ScrollLocked({ child: portal });
  }
}
