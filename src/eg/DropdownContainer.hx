package eg;

import pine.*;

class DropdownContainer extends AutoComponent {
  final children:Children;
  
  function render(context:Context) {
    return new Fragment({
      children: children
    });
  }
}
