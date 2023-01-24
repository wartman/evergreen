package eg;

import pine.*;
import pine.html.*;

using pine.core.OptionTools;

class DropdownPanel extends AutoComponent {
  public final onHide:()->Void;
  final attachment:PositionedAttachment;
  final child:HtmlChild;

  function render(context:Context) {
    #if (js && !nodejs)
    DropdownHooks.useDropdown(context);
    #end
    return new Popover({
      getTarget: () -> context
        .queryAncestors()
        .ofType(Dropdown)
        .orThrow('No Dropdown')
        .queryChildren()
        .findOfType(DropdownToggle, true)
        .orThrow('No dropdown toggle')
        .getObject(),
      attachment: attachment,
      child: child
    });
  }
}
