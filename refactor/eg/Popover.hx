package eg;

import pine.*;
import pine.html.*;

using Nuke;

class Popover extends AutoComponent {
  final child:HtmlChild;
  final styles:ClassName = null;
  final attachment:PositionedAttachment;
  final getTarget:Null<()->Dynamic> = null;

  function render(context:Context) {
    return new Portal({
      target: PortalContext.from(context).getTarget(),
      child: new Positioned({
        getTarget: getTarget != null 
          ? getTarget 
          : () -> switch context.queryAncestors().ofType(ObjectComponent) {
            case Some(parent): parent.getObject();
            case None: throw 'No parent object';
          },
        attachment: attachment,
        child: child
      })
    });
  }
}
