package system;

import pine.*;
import pine.html.*;
import pine.html.HtmlEvents;

using Breeze;

enum ButtonPriority {
  Primary;
  Normal;
}

class Button extends AutoComponent {
  final action:(e:Event)->Void;
  final label:Child;
  final priority:ButtonPriority = Normal;

  function build() {
    return new Html<'button'>({
      className: Breeze.compose(
        Spacing.pad('y', 1),
        Spacing.pad('x', 3),
        Typography.fontWeight('bold'),
        Border.radius(2),
        Border.style('solid'),
        Border.width(.5),
        Border.color('black', 0),
        switch priority {
          case Primary: Background.color('sky', 200);
          case Normal: null;
        }
      ),
      onClick: action,
      children: [ label ]
    });
  }
}

