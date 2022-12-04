package eg;

import pine.*;
import pine.html.*;

class DropdownItem extends AutoComponent {
  final child:HtmlChild;
  
  function render(context:Context) {
    return child;
  }
}
