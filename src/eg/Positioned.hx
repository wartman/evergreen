package eg;

import pine.*;

class Positioned extends AutoComponent {
  public final getTarget:()->Dynamic;
  public final attachment:PositionedAttachment;
  final child:Child;

  function render(context:Context) {
    #if (js && !nodejs)
    PositionedHooks.usePosition(context);
    #end
    return child;
  }
}
