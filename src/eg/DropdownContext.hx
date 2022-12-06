package eg;

import pine.*;

enum abstract DropdownStatus(Bool) {
  final Open = true;
  final Closed = false;
}

typedef DropdownContextProvider = Provider<DropdownContext>; 

class DropdownContext implements Record {
  public inline static function from(context:Context) {
    return DropdownContextProvider.from(context);
  }

  public final attachment:PositionedAttachment;
  public var status:DropdownStatus;

  public function open() {
    status = Open;
  }

  public function close() {
    status = Closed;
  }

  public function toggle() {
    status = status == Open ? Closed : Open;
  }
}
