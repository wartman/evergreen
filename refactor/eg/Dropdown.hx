package eg;

import pine.*;
import pine.html.*;
import eg.DropdownContext;

using Nuke;

class Dropdown extends AutoComponent {
  final attachment:PositionedAttachment = { h: Middle, v: Bottom };
  final styles:ClassName = null;
  final label:HtmlChild;
  final child:HtmlChild;
  final status:DropdownStatus = Closed;

  function render(context:Context) {
    return new DropdownContextProvider({
      create: () -> new DropdownContext({ status: status, attachment: attachment }),
      dispose: dropdown -> dropdown.dispose(),
      render: dropdown -> new Html<'button'>({
        className: styles,
        onclick: e -> {
          e.preventDefault();
          dropdown.toggle();
        },
        children: [
          label,
          new Scope({
            render: context -> switch dropdown.status {
              case Open: 
                new DropdownContainer({
                  onHide: () -> dropdown.close(),
                  child: new Popover({
                    attachment: attachment,
                    child: child
                  })
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
