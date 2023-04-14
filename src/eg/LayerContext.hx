package eg;

import pine.*;
import pine.signal.*;

typedef LayerContextProvider = Provider<LayerContext>;

enum LayerContextStatus {
  Showing;
  Hiding;
}

// @todo: Replace this with a LayerManager or something -- some way to
// handle multiple layers being active at once.
@:allow(eg)
class LayerContext implements Record {
  public static function from(context:Component) {
    return LayerContextProvider.from(context);
  }
  
  public final status:Signal<LayerContextStatus> = Showing;

  public function hide():Void {
    status.set(Hiding);
  }
  
  public function show():Void {
    status.set(Showing);
  }
}
