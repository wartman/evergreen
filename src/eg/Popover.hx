package eg;

import pine.*;

using Nuke;

class Popover extends AutoComponent {
  final child:Child;
  final styles:ClassName = null;
  final attachment:PositionedAttachment;
  final getTarget:Null<()->Dynamic> = null;

  function build() {
    return new Portal(PortalContext.from(this).getTarget(), () -> new Positioned({
      getTarget: getTarget ?? () -> findAncestorOfType(ObjectComponent)
        .map(parent -> parent.getObject())
        .orThrow('No parent object'),
      attachment: attachment,
      child: child
    }));
  }
}
