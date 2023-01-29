package eg;

import pine.*;
import eg.DropdownContext;

using Nuke;
using pine.core.OptionTools;

class Dropdown extends AutoComponent {
  final attachment:PositionedAttachment = { h: Middle, v: Bottom };
  final toggle:Child;
  final child:Child;
  final status:DropdownStatus = Closed;

  function render(context:Context) {
    return new DropdownContextProvider({
      create: () -> new DropdownContext({ status: status, attachment: attachment }),
      dispose: dropdown -> dropdown.dispose(),
      render: dropdown -> new DropdownContainer({
        children: [
          new DropdownToggle({ 
            child: toggle 
          }),
          new Scope({
            render: context -> switch dropdown.status {
              case Open:
                new DropdownPanel({
                  onHide: () -> dropdown.close(),
                  attachment: attachment,
                  child: child
                });
              case Closed:
                null;
            }
          })
        ]
      })
    });
  }
}
