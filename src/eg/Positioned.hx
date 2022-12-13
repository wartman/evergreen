package eg;

import pine.*;
import pine.html.*;

#if (js && !nodejs)
@:hook(PositionedHooks.controlElementPosition())
#end
class Positioned extends AutoComponent {
  public final getTarget:()->Dynamic;
  public final attachment:PositionedAttachment;
  final child:HtmlChild;

  function render(context:Context) {
    return child;
  }
}
