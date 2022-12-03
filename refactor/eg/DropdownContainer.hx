package eg;

import haxe.ds.Option;
import pine.*;
import pine.html.*;

#if (js && !nodejs)
@:hook(element -> new DropdownController(element))
#end
class DropdownContainer extends AutoComponent {
  @:prop public final onHide:()->Void;
  @:prop final child:HtmlChild;

  function render(context:Context) {
    return child;
  }
}
