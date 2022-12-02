package eg;

import pine.*;
import pine.html.*;

#if (js && !nodejs)
@:controller(new PositionController())
#end
class Positioned extends AutoComponent {
  @:prop public final getTarget:()->Dynamic;
  @:prop public final attachment:PositionedAttachment;
  @:prop final child:HtmlChild;

  function render(context:Context) {
    return child;
  }
}
