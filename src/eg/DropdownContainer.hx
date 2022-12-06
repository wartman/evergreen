package eg;

import pine.*;
import pine.html.*;

class DropdownContainer extends AutoComponent {
  final children:HtmlChildren;
  
  function render(context:Context) {
    return new Fragment({
      children: children
    });
  }
}
