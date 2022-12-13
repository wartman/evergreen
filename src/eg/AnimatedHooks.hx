package eg;

import pine.*;
import js.html.Element as DomElement;
import js.html.Animation;

using eg.internal.DomAnimationTools;

function controlElementAnimation():Hook<Animated> {
  return element -> {
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

    element.watchLifecycle({
      afterInit: element -> registerAnimation(element, true),
      afterUpdate: element -> registerAnimation(element, false),
      beforeDispose: element -> {
        if (currentAnimation != null) {
          currentAnimation.cancel();
          currentAnimation = null;
        }
        currentKeyframes = null;
        if (element.component.onDispose != null) {
          element.component.onDispose(element);
        }
      }
    });
  }
}
