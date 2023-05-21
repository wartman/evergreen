package system;

import breeze.ClassName;
import breeze.rule.Border;
import breeze.rule.Spacing;
import pine.*;
import pine.html.*;

class Panel extends AutoComponent {
  final styles:ClassName = null;
  final children:Children;

  function build() {
    return new Html<'div'>({
      className: ClassName.ofArray([
        borderRadius(2),
        borderColor('black', 0),
        borderWidth(.5),
        pad(4),
        styles
      ]),
      children: children
    });
  }
}