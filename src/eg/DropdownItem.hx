package eg;

import pine.*;
import pine.html.*;

class DropdownItem extends ImmutableComponent {
  @prop final child:HtmlChild;
  
  function render(context:Context) {
    return child;
  }
}
