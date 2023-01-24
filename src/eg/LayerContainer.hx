package eg;

import pine.*;
import pine.html.*;
import eg.Layer;

using Nuke;
using pine.core.OptionTools;

class LayerContainer extends AutoComponent {
  public final hideOnEscape:Bool;
  final child:HtmlChild;

  function render(context:Context) {
    #if (js && !nodejs)
    var hook = Hook.from(context);
    CoreHooks.takeFocus(hook, element -> element
      .queryChildren()
      .findOfType(LayerTarget, true)
      .orThrow('Expected a LayerTarget')
      .getObject()
    );
    CoreHooks.watchKeyPressEvents(hook, (e, element:ElementOf<LayerContainer>) -> switch e.key {
      case 'Escape' if (element.component.hideOnEscape):
        e.preventDefault();
        LayerContext.from(element).hide();
      default:
    });
    #end
    return child;
  }
}
