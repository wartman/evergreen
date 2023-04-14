package eg;

import pine.*;
import pine.signal.*;

typedef CollapseContextProvider = Provider<CollapseContext>;

enum abstract CollapseContextStatus(Bool) {
  final Collapsed = false;
  final Expanded = true;
}

class CollapseContext implements Record {
  public static function from(context:Component) {
    return switch CollapseContextProvider.maybeFrom(context) {
      case Some(collapse): collapse;
      case None: throw 'No collapse context was found';
    }
  }

  public final status:Signal<CollapseContextStatus>;
  public final duration:Int = 200;

  public function toggle() {
    switch status.peek() {
      case Expanded: collapse();
      case Collapsed: expand();
    }
  }

  public function expand() {
    status.set(Expanded);
  }

  public function collapse() {
    status.set(Collapsed);
  }
}
