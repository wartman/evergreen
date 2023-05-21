package eg;

import eg.Layer;
import pine.*;

class LayerContainer extends AutoComponent {
  final hideOnEscape:Bool;
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
    addDisposable(() -> {
      document.removeEventListener('keydown', onEscape);
      FocusContext.from(this).returnFocus();
    });
    #end
    return child;
  }
}
