package eg;

import pine.*;

typedef LayerContextProvider = Provider<LayerContext>;

enum LayerContextStatus {
  Showing;
  Hiding;
}

// @todo: Replace this with a LayerManager or something -- some way to
// handle multiple layers being active at once.
@:allow(eg)
class LayerContext extends Record {
  public static function from(context:Component) {
    return LayerContextProvider.from(context);
  }
  
  @:signal public final status:LayerContextStatus = Showing;

  public function hide():Void {
    status.set(Hiding);
  }
  
  public function show():Void {
    status.set(Showing);
  }
}
