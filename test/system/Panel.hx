package system;

import pine.*;
import pine.html.*;

using Breeze;

class Panel extends AutoComponent {
  final styles:ClassName = null;
  final children:Children;

  function build() {
    return new Html<'div'>({
      className: ClassName.ofArray([
        Border.radius(2),
        Border.color('black', 0),
        Border.width(.5),
        Spacing.pad(4),
        styles
      ]),
      children: children
    });
  }
}