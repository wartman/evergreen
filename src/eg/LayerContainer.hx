package eg;

import eg.Layer;
import pine.*;

using Nuke;

class LayerContainer extends AutoComponent {
  public final hideOnEscape:Bool;
  final child:Child;

  function build() {
    #if (js && !nodejs)
    var document = js.Browser.document;

    function onEscape(e:js.html.KeyboardEvent) switch e.key {
      case 'Escape' if (hideOnEscape):
        e.preventDefault();
        LayerContext.from(this).hide();
      default:
    }

    onMount(() -> {
      document.addEventListener('keydown', onEscape);
      var obj = findChildOfType(LayerTarget, true)
        .orThrow('Expected a LayerTarget')
        .getObject();
      FocusContext.from(this).focus(obj);
    });
    onCleanup(() -> {
      document.removeEventListener('keydown', onEscape);
      FocusContext.from(this).returnFocus();
    });
    #end
    return child;
  }
}
