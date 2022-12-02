package eg;

import haxe.ds.Option;
import pine.*;
import pine.html.*;

#if (js && !nodejs)
@:controller(new DropdownController())
#end
class DropdownContainer extends AutoComponent {
  @:prop public final onHide:()->Void;
  @:prop final child:HtmlChild;

  function render(context:Context) {
    return child;
  }
}
