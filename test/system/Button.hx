package system;

import breeze.ClassName;
import breeze.rule.Background;
import breeze.rule.Border;
import breeze.rule.Spacing;
import breeze.rule.Typography;
import pine.*;
import pine.html.*;
import pine.html.HtmlEvents;

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
      className: ClassName.ofArray([
        borderRadius(2),
        pad('y', 1),
        pad('x', 3),
        fontWeight('bold'),
        borderStyle('solid'),
        borderWidth(.5),
        borderColor('black', 0),
        switch priority {
          case Primary: bgColor('sky', 200);
          case Normal: null;
        }
      ]),
      onClick: action,
      children: [ label ]
    });
  }
}

