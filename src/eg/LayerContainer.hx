package eg;

import eg.Layer;
import pine.*;

using Nuke;

class LayerContainer extends AutoComponent {
  public final hideOnEscape:Bool;
  final child:Child;

  function render(context:Context) {
    #if (js && !nodejs)
    return new Proxy<LayerContainer>({
      target: context,
      setup: element -> {
        var document = js.Browser.document;

        function onEscape(e:js.html.KeyboardEvent)  switch e.key {
          case 'Escape' if (element.component.hideOnEscape):
            e.preventDefault();
            LayerContext.from(context).hide();
          default:
        }
        
        element.onInit(() -> {
          document.addEventListener('keydown', onEscape);
          FocusContext.from(context).focus(element
            .queryChildren()
            .findOfType(LayerTarget, true)
            .orThrow('Expected a LayerTarget')
            .getObject());
          return () -> {
            document.removeEventListener('keydown', onEscape);
            FocusContext.from(context).returnFocus();
          }
        });
      },
      child: child
    });
    #else
    return child;
    #end
  }
}
