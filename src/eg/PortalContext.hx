package eg;

import pine.*;
import pine.debug.Debug;
import pine.core.Disposable;

typedef PortalContextProvider = pine.Provider<PortalContext>;

class PortalContext implements Disposable {
  public static function from(context:Context):PortalContext {
    return switch PortalContextProvider.maybeFrom(context) {
      case Some(portal): portal;
      // @todo: Create a default portal if none exists.
      case None: Debug.error('No PortalContext was found');
    }
  }

  #if (js && !nodejs)
  final target:js.html.Element;
  #else
  final target:pine.object.Object;
  #end

  public function new(target) {
    this.target = target;
  }

  public function getTarget() {
    return target;
  }

  public function dispose() {}
}
