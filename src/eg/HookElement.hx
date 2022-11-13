package eg;

import pine.*;

@component(HookComponent)
abstract class HookElement extends Element {
  var child:Null<Element> = null;

  abstract function onUpdate(previousComponent:Null<Component>):Void;

  function performHydrate(cursor:HydrationCursor) {
    child = hydrateElementForComponent(cursor, hookComponent.getChild(), slot);
    onUpdate(null);
  }

  function performBuild(previousComponent:Null<Component>) {
    child = updateChild(child, hookComponent.getChild(), slot);
    onUpdate(previousComponent);
  }

  public function visitChildren(visitor:ElementVisitor) {
    if (child != null) visitor.visit(child);
  }
}
