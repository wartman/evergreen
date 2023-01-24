package eg;

import pine.*;
import pine.html.*;

class Positioned extends AutoComponent {
  public final getTarget:()->Dynamic;
  public final attachment:PositionedAttachment;
  final child:HtmlChild;

  function render(context:Context) {
    #if (js && !nodejs)
    PositionedHooks.usePosition(Hook.from(context));
    #end
    return child;
  }
}
