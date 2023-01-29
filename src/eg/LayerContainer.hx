package eg;

import eg.Layer;
import pine.*;

using Nuke;
using pine.core.OptionTools;
#if (js && !nodejs)
using eg.CoreHooks;
#end

class LayerContainer extends AutoComponent {
  public final hideOnEscape:Bool;
  final child:Child;

  function render(context:Context) {
    #if (js && !nodejs)
    context.useFocus(element -> element
      .queryChildren()
      .findOfType(LayerTarget, true)
      .orThrow('Expected a LayerTarget')
      .getObject()
    );
    context.useKeyPressEvents((e, element:ElementOf<LayerContainer>) -> switch e.key {
      case 'Escape' if (element.component.hideOnEscape):
        e.preventDefault();
        LayerContext.from(element).hide();
      default:
    });
    #end
    return child;
  }
}
