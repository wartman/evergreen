package eg;

import pine.*;
import pine.html.*;
import eg.Box;

using Nuke;

class DropdownItem extends ImmutableComponent {
  @prop final tag:BoxTag = ListItem;
  @prop final styles:ClassName = null;
  @prop final children:HtmlChildren;
  
  function render(context:Context) {
    return new Box({
      tag: tag,
      styles: styles,
      children: children
    });
  }
}
