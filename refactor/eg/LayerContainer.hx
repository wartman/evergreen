package eg;

import pine.*;
import pine.html.*;
import eg.Layer;

using Nuke;
using pine.core.OptionTools;

#if (js && !nodejs)
@:controller(
  new FocusController(element -> LayerTarget
    .maybeFrom(element)
    .orThrow('Expected a LayerTarget')
    .getObject()
  ),
  new KeyboardController<LayerContainer>((e, element) -> switch e.key {
    case 'Escape' if (element.getComponent().hideOnEscape):
      e.preventDefault();
      LayerContext.from(element).hide();
    default:
  })
)
#end
class LayerContainer extends AutoComponent {
  @:prop public final hideOnEscape:Bool;
  @:prop final child:HtmlChild;

  function render(context:Context) {
    return child;
  }
}
