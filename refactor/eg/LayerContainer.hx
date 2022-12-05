package eg;

import pine.*;
import pine.html.*;
import eg.Layer;

using Nuke;
using pine.core.OptionTools;

#if (js && !nodejs)
@:hook(
  CoreHooks.takeFocus(element -> element
    .queryChildren()
    .findOfType(LayerTarget, true)
    .orThrow('Expected a LayerTarget')
    .getObject()
  ),
  CoreHooks.watchKeypressEvents((e, element:ElementOf<LayerContainer>) -> switch e.key {
    case 'Escape' if (element.component.hideOnEscape):
      e.preventDefault();
      LayerContext.from(element).hide();
    default:
  })
)
#end
class LayerContainer extends AutoComponent {
  public final hideOnEscape:Bool;
  final child:HtmlChild;

  function render(context:Context) {
    return child;
  }
}
