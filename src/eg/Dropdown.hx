package eg;

import pine.*;
import eg.DropdownContext;

using Nuke;

class Dropdown extends AutoComponent {
  final attachment:PositionedAttachment = { h: Middle, v: Bottom };
  final toggle:(context:DropdownContext)->Child;
  final body:(context:DropdownContext)->Child;
  final status:DropdownStatus = Closed;

  function build() {
    return new DropdownContextProvider({
      create: () -> new DropdownContext({ status: status, attachment: attachment }),
      // dispose: dropdown -> dropdown.dispose(),
      dispose: _ -> null,
      build: dropdown -> new DropdownContainer({
        children: [
          new DropdownToggle({ child: toggle(dropdown) }),
          new Scope(_ -> switch dropdown.status() {
            case Open:
              new DropdownPanel({
                onHide: () -> dropdown.close(),
                attachment: attachment,
                child: body(dropdown)
              });
            case Closed:
              new Placeholder();
          })
        ]
      })
    });
  }
}
