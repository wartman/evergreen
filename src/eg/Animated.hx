package eg;

import pine.*;

#if (js && !nodejs)
import js.html.Element as DomElement;
import js.html.Animation;

using eg.internal.DomAnimationTools;
#end

class Animated extends HookComponent {
  @prop public final dontAnimateInitial:Bool = false;
  @prop public final createKeyframes:KeyframeFactory;
  @prop public final duration:Int;
  @prop public final onFinished:(context:Context)->Void = null;
  @prop public final onDispose:(context:Context)->Void = null;

  public function createElement():Element {
    return new AnimatedElement(this);
  }
}

@component(Animated)
class AnimatedElement extends HookElement {
  function onUpdate(previousComponent:Null<Component>) {
    #if (js && !nodejs)
    if (previousComponent == null || component != previousComponent) {
      registerAnimation(previousComponent == null);
    }
    #end
  }

  function performDispose() {
    #if (js && !nodejs)
    if (currentAnimation != null) {
      currentAnimation.cancel();
      currentAnimation = null;
    }
    #end
    if (animated.onDispose != null) animated.onDispose(this);
  }

  #if (js && !nodejs)
  var currentAnimation:Null<Animation> = null;

  function registerAnimation(first:Bool = false) {
    if (currentAnimation != null) currentAnimation.cancel();
    
    var el:DomElement = getObject();
    var duration = first && animated.dontAnimateInitial ? 0 : animated.duration;
    var keyframes = animated.createKeyframes(this);

    currentAnimation = el.registerAnimations(keyframes, duration, onFinished);
  }

  function onFinished() {
    if (currentAnimation != null) currentAnimation = null;
    if (animated.onFinished != null) animated.onFinished(this);
  }
  #end
}
