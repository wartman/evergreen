package eg;

import pine.*;

class DropdownItem extends AutoComponent {
  final child:Child;
  
  function render(context:Context) {
    return child;
  }
}
