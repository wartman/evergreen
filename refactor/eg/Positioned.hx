package eg;

import pine.*;
import pine.html.*;

#if (js && !nodejs)
@:hook(element -> new PositionController(element))
#end
class Positioned extends AutoComponent {
  public final getTarget:()->Dynamic;
  public final attachment:PositionedAttachment;
  final child:HtmlChild;

  function render(context:Context) {
    return child;
  }
}
