package eg;

import haxe.ds.Option;
import pine.*;
import pine.html.*;

using pine.core.OptionTools;

#if (js && !nodejs)
// @todo: Can we use our `takeFocus` and `watchKeypressEvents`
// hooks here instead of making the Controller do everything?
@:hook(DropdownController.new)
#end
class DropdownPanel extends AutoComponent {
  public final onHide:()->Void;
  final attachment:PositionedAttachment;
  final child:HtmlChild;

  function render(context:Context) {
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
