package eg;

import pine.*;

class Popover extends AutoComponent {
  final child:Child;
  final gap:Int = 0;
  final attachment:PositionedAttachment;
  final getTarget:Null<()->Dynamic> = null;

  function build() {
    var target = PortalContext.from(this).getTarget();
    return new Portal(target, () -> new Positioned({
      getTarget: getTarget ?? () -> findAncestorOfType(ObjectComponent)
        .map(parent -> parent.getObject())
        .orThrow('No parent object'),
      gap: gap,
      attachment: attachment,
      child: child
    }));
  }
}
