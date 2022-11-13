package spruce.dropdown;

import pine.*;
import pine.html.*;
import eg.DropdownContext;

using Nuke;

class DropdownButton extends ImmutableComponent {
  @prop public final attachment:PositionedAttachment = { h: Middle, v: Bottom };
  @prop final styles:ClassName = null;
  @prop final label:HtmlChild;
  @prop final child:HtmlChild;
  @prop final status:DropdownStatus = Closed;

  function render(context:Context) {
    return new DropdownContextProvider({
      create: () -> new DropdownContext({ status: status, attachment: attachment }),
      dispose: dropdown -> dropdown.dispose(),
      render: dropdown -> new Box({
        styles: styles,
        onclick: _ -> dropdown.toggle(),
        children: [
          label,
          new Isolate({
            wrap: context -> switch dropdown.status {
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
