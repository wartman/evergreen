package eg;

import pine.*;
import js.html.Element as DomElement;
import js.html.Animation;

using eg.internal.DomAnimationTools;

class AnimatedLifecycleController implements Controller<Animated> {
  var currentAnimation:Null<Animation> = null;

  public function new() {}

	public function register(element:ElementOf<Animated>) {
    element.addHook({
      afterInit: init,
      afterUpdate: update,
      // shouldUpdate: (element, current, incoming, isRebuild) -> {
      //   // @todo: Check if we're actually trying to change animation state?
      //   true;
      // },
      onDispose: element -> {
        if (element.getComponent().onDispose != null) {
          element.getComponent().onDispose(element);
        }
      }
    });
  }

  public function init(element:ElementOf<Animated>) {
    registerAnimation(element, true);
  }

  public function update(element:ElementOf<Animated>) {
    registerAnimation(element, false);
  }

  public function dispose() {
    if (currentAnimation != null) {
      currentAnimation.cancel();
      currentAnimation = null;
    }
  }

  function registerAnimation(element:ElementOf<Animated>, first:Bool = false) {
    if (currentAnimation != null) currentAnimation.cancel();
    
    var animated = element.getComponent();
    var el:DomElement = element.getObject();
    var duration = first && animated.dontAnimateInitial ? 0 : animated.duration;
    var keyframes = animated.createKeyframes(element);
    
    function onFinished() {
      if (currentAnimation != null) currentAnimation = null;
      if (animated.onFinished != null) animated.onFinished(element);
    }

    currentAnimation = el.registerAnimations(keyframes, {
      duration: duration,
      easing: animated.easing,
      iterations: if (animated.infinite) Math.POSITIVE_INFINITY else 1
    }, onFinished);
  }
}
