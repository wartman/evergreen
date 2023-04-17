package eg;

import kit.Assert;
import pine.*;

using Nuke;

class CollapseItem extends AutoComponent {
  final child:Child;
 
  function build() {
    assert(!(child is Fragment));

    var collapse = CollapseContext.from(this);
 
    return new Animated({
      dontAnimateInitial: true,
      keyframes: collapse.status.map(status -> switch status {
        case Collapsed: new Keyframes('in', context -> [
          { height: getHeight(context), offset: 0 },
          { height: 0, offset: 1 }
        ]);
        case Expanded: new Keyframes('out', context -> [
          { height: 0, offset: 0 },
          { height: getHeight(context), offset: 1 }
        ]);
      }),
      onFinished: context -> {
        #if (js && !nodejs)
        var el:js.html.Element = getObject();
        switch collapse.status.peek() {
          case Collapsed: el.style.height = '0';
          case Expanded: el.style.height = 'auto';
        }
        #end
      },
      duration: collapse.duration,
      child: child
    });
  }
}

private function getHeight(context:Component) {
  #if (js && !nodejs)
  var el:js.html.Element = context.getObject();
  return el.scrollHeight.px();
  #else
  return 'auto';
  #end
}
