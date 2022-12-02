package eg;

import pine.*;

typedef CollapseContextProvider = Provider<CollapseContext>;

enum abstract CollapseContextStatus(Bool) {
  final Collapsed = false;
  final Expanded = true;
}

class CollapseContext implements Record {
  public static function from(context:Context) {
    return switch CollapseContextProvider.maybeFrom(context) {
      case Some(collapse): collapse;
      case None: throw 'No collapse context was found';
    }
  }

  @:track public var status:CollapseContextStatus;
  @:prop public final duration:Int = 200;

  public function toggle() {
    switch status {
      case Expanded: collapse();
      case Collapsed: expand();
    }
  }

  public function expand() {
    status = Expanded;
  }

  public function collapse() {
    status = Collapsed;
  }
}
