package eg;

import pine.*;
import pine.html.*;
import eg.internal.DomTools;

using Nuke;

class Modal extends AutoComponent {
  final styles:ClassName = null;
  final layerStyles:ClassName = null;
  final onHide:()->Void;
  final children:HtmlChildren;
  final hideOnEscape:Bool = true;

  public function render(context:Context):Component {
    return new Portal({
      target: PortalContext.from(context).getTarget(),
      child: new Layer({
        styles: layerStyles,
        hideOnEscape: hideOnEscape,
        beforeShow: () -> {
          lockBody();
        },
        onHide: () -> {
          unlockBody();
          onHide();
        },
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
  }
}
