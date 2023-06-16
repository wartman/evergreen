package eg;

import pine.*;
import eg.DropdownContext;

class Dropdown extends AutoComponent {
  final attachment:PositionedAttachment = { h: Middle, v: Bottom };
  final gap:Int = 0;
  final toggle:(context:DropdownContext)->Child;
  final child:(context:DropdownContext)->Child;
  final status:DropdownStatus = Closed;

  function build() {
    return new DropdownContextProvider({
      value: new DropdownContext({ 
        status: status,
        attachment: attachment,
        gap: gap
      }),
      child: dropdown -> new DropdownContainer({
        children: [
          new DropdownToggle({ child: toggle(dropdown) }),
          new Scope(context -> switch dropdown.status() {
            case Open:
              new DropdownPanel({
                onHide: () -> dropdown.close(),
                attachment: attachment,
                gap: gap,
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
