package eg;

import pine.*;

enum abstract DropdownStatus(Bool) {
  final Open = true;
  final Closed = false;
}

typedef DropdownContextProvider = Provider<DropdownContext>; 

class DropdownContext extends Record {
  public inline static function from(context:Component) {
    return DropdownContextProvider.from(context);
  }

  public final attachment:PositionedAttachment;
  public final gap:Int;
  @:signal public final status:DropdownStatus;

  public function open() {
    status.set(Open);
  }

  public function close() {
    status.set(Closed);
  }

  public function toggle() {
    status.update(status -> status == Open ? Closed : Open);
  }
}
