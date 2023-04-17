package eg;

import pine.*;

typedef CollapseContextProvider = Provider<CollapseContext>;

enum abstract CollapseContextStatus(Bool) {
  final Collapsed = false;
  final Expanded = true;
}

class CollapseContext extends Record {
  public static function from(context:Component) {
    return switch CollapseContextProvider.maybeFrom(context) {
      case Some(collapse): collapse;
      case None: throw 'No collapse context was found';
    }
  }

  public final duration:Int = 200;
  @:signal public final status:CollapseContextStatus;

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
