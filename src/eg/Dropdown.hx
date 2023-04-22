package eg;

import pine.*;
import eg.DropdownContext;

using Nuke;

class Dropdown extends AutoComponent {
  final attachment:PositionedAttachment = { h: Middle, v: Bottom };
  final toggle:(context:DropdownContext)->Child;
  final child:(context:DropdownContext)->Child;
  final status:DropdownStatus = Closed;

  function build() {
    return new DropdownContextProvider({
      value: new DropdownContext({ status: status, attachment: attachment }),
      child: dropdown -> new DropdownContainer({
        children: [
          new DropdownToggle({ child: toggle(dropdown) }),
          new Scope(_ -> switch dropdown.status() {
            case Open:
              new DropdownPanel({
                onHide: () -> dropdown.close(),
                attachment: attachment,
                child: child(dropdown)
              });
            case Closed:
              new Placeholder();
          })
        ]
      })
    });
  }
}
