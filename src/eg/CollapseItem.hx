package eg;

import pine.*;
import pine.html.*;

using Nuke;

class CollapseItem extends ObserverComponent {
  @prop final child:HtmlChild;
 
  function render(context:Context) {
    Debug.assert(!(child is Fragment));

    var collapse = CollapseContext.from(context);

    return new Animated({
      dontAnimateInitial: true,
      createKeyframes: switch collapse.status {
        case Collapsed: context -> [
          { height: getHeight(context), offset: 0 },
          { height: 0, offset: 1 }
        ];
        case Expanded: context -> [
          { height: 0, offset: 0 },
          { height: getHeight(context), offset: 1 }
        ];
      },
      onFinished: context -> {
        #if (js && !nodejs)
        var el:js.html.Element = context.getObject();
        switch collapse.status {
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

private function getHeight(context:Context) {
  #if (js && !nodejs)
  var el:js.html.Element = context.getObject();
  return el.scrollHeight.px();
  #else
  return 'auto';
  #end
}
