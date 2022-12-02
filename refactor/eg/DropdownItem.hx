package eg;

import pine.*;
import pine.html.*;

class DropdownItem extends AutoComponent {
  @:prop final child:HtmlChild;
  
  function render(context:Context) {
    return child;
  }
}
