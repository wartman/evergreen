package eg;

import pine.*;
import pine.html.*;

using Nuke;

class Popover extends AutoComponent {
  @:prop final child:HtmlChild;
  @:prop final styles:ClassName = null;
  @:prop final attachment:PositionedAttachment;
  @:prop final getTarget:Null<()->Dynamic> = null;

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
