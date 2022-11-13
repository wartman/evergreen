package eg;

import pine.*;
import pine.html.*;
import eg.internal.DomTools;

using Nuke;

class Modal extends ImmutableComponent {
  @prop final styles:ClassName = null;
  @prop final onHide:()->Void;
  @prop final children:HtmlChildren;
  @prop final hideOnEscape:Bool = true;

  public function render(context:Context):Component {
    return new Portal({
      target: PortalContext.from(context).getTarget(),
      child: new Layer({
        hideOnEscape: hideOnEscape,
        beforeShow: () -> {
          lockBody();
        },
        onHide: () -> {
          unlockBody();
          onHide();
        },
        child: new Box({
          styles: [
            'eg-modal-container',
            styles
          ],
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
