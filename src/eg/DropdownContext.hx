package eg;

import pine.*;
import pine.signal.*;

enum abstract DropdownStatus(Bool) {
  final Open = true;
  final Closed = false;
}

typedef DropdownContextProvider = Provider<DropdownContext>; 

class DropdownContext implements Record {
  public inline static function from(context:Component) {
    return DropdownContextProvider.from(context);
  }

  public final attachment:PositionedAttachment;
  public final status:Signal<DropdownStatus>;

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
