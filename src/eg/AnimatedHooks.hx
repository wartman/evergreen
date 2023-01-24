package eg;

import pine.*;
import js.html.Element as DomElement;
import js.html.Animation;

using eg.internal.DomAnimationTools;
using pine.CoreHooks;

function controlElementAnimation(hook:Hook<Animated>) {
  hook.useElement(element -> {
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

    var links = [
      element.events.afterInit.add((element, _) -> registerAnimation(element, true)),
      element.events.afterUpdate.add(element -> registerAnimation(element, false)),
      element.events.beforeDispose.add(_ -> if (element.component.onDispose != null) {
        element.component.onDispose(element);
      })
    ];

    () -> {
      if (currentAnimation != null) {
        currentAnimation.cancel();
        currentAnimation = null;
      }
      currentKeyframes = null; 
      for (cancel in links) cancel();
    };
  });
}
