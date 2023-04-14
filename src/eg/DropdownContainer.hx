package eg;

import pine.*;

class DropdownContainer extends AutoComponent {
  final children:Children;
  
  function build() {
    return new Fragment(children);
  }
}
