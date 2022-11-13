package eg;

import pine.*;

class LayerTarget extends ImmutableComponent {
  public static function maybeFrom(context:Context) {
    return context.queryFirstChild(child -> child.getComponent().getComponentType() == LayerTarget.componentType);
  }
  
  @prop final child:Component;

  function render(context:Context) {
    return child;
  }
}
