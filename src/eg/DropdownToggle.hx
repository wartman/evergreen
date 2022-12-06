package eg;

import pine.*;
import pine.html.*;

class DropdownToggle extends AutoComponent {
  final child:HtmlChild;
  
  function render(context:Context) {
    return child;
  }
}
