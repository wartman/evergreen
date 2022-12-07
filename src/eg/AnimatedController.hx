package eg;

import pine.*;
import pine.core.Disposable;
import js.html.Element as DomElement;
import js.html.Animation;

using eg.internal.DomAnimationTools;

class AnimatedController implements Disposable {
  var currentKeyframes:Null<Keyframes> = null;
  var currentAnimation:Null<Animation> = null;
  final element:ElementOf<Animated>;

  public function new(element) {
    this.element = element;
    element.addDisposable(this);
    element.watchLifecycle({
      afterInit: init,
      afterUpdate: update,
      onDispose: element -> {
        if (element.component.onDispose != null) {
          element.component.onDispose(element);
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
    var animated = element.component;
    var el:DomElement = element.getObject();
    var duration = first && animated.dontAnimateInitial ? 0 : animated.duration;
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
}
