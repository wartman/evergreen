package eg;

import pine.*;
import js.html.Element as DomElement;
import js.html.Animation;

using eg.internal.DomAnimationTools;

function useAnimation(element:ElementOf<Animated>) {
  var hook = Hook.from(element);
  var animation = hook.useMemo(
    () -> createAnimationController(), 
    animation -> animation.dispose()
  );
  hook.useInit(() -> animation.registerAnimation(element, true));
  hook.useUpdate(() -> animation.registerAnimation(element, false));
  hook.useCleanup(() -> if (element.component.onDispose != null) {
    element.component.onDispose(element);
  });
}

function createAnimationController() {
  var currentKeyframes:Null<Keyframes> = null;
  var currentAnimation:Null<Animation> = null;

  function registerAnimation(element:ElementOf<Animated>, first:Bool = false) {
    var animated = element.component;
    var el:DomElement = element.getObject();
    var duration = if (first && animated.dontAnimateInitial) 0 else animated.duration;
    var keyframes = animated.keyframes;

    if (animated.dontRepeatCurrentAnimation) {
      if (currentKeyframes != null && currentKeyframes.equals(keyframes)) {
        return;
      }
    }

    currentKeyframes = keyframes;
    
    if (currentAnimation != null) {
      currentAnimation.cancel();
      currentAnimation = null;
    }
    
    function onFinished() {
      currentAnimation = null;
      if (animated.onFinished != null) animated.onFinished(element);
    }

    currentAnimation = el.registerAnimations(keyframes.create(element), {
      duration: duration,
      easing: animated.easing,
      iterations: if (animated.infinite) Math.POSITIVE_INFINITY else 1
    }, onFinished);
  }

  return {
    registerAnimation: registerAnimation,
    dispose: () -> if (currentAnimation != null) currentAnimation.cancel()
  };
}
