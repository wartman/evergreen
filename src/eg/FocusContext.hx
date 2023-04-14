package eg;

import pine.*;

typedef FocusContextProvider = Provider<FocusContext>; 

class FocusContext {
  static var instance:Null<FocusContext> = null;

  public inline static function from(context:Component) {
    return switch FocusContextProvider.maybeFrom(context) {
      case Some(focus): 
        return focus;
      case None if (instance == null): 
        instance = new FocusContext();
        return instance;
      case None:
        return instance;
    }
  }

  #if (js && !nodejs)
  var previous:Null<js.html.Element> = null;
  #end

  public function new() {}

  public function focus(object:Dynamic) {
    #if (js && !nodejs)
    var el:js.html.Element = object;
    if (previous == null) {
      previous = el.ownerDocument.activeElement;
    }
    el.focus();
    #end
  }

  public function returnFocus() {
    #if (js && !nodejs)
    if (previous != null) {
      previous.focus();
      previous = null;
    }
    #end
  }
}
