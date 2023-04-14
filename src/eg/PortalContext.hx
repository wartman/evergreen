package eg;

import pine.*;

typedef PortalContextProvider = pine.Provider<PortalContext>;

class PortalContext implements Disposable {
  public static function from(context:Component):PortalContext {
    return PortalContextProvider
      .maybeFrom(context)
      .orThrow('No PortalContext was found');
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
