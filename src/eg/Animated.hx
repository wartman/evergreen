package eg;

import pine.*;

#if (js && !nodejs)
import js.html.Element as DomElement;
import js.html.Animation;

using eg.internal.DomAnimationTools;
#end

class Animated extends AutoComponent {
  public final dontAnimateInitial:Bool = false;
  public final dontRepeatCurrentAnimation:Bool = true;
  public final keyframes:Keyframes;
  public final duration:Int;
  public final infinite:Bool = false;
  public final easing:String = 'linear';
  public final onFinished:(context:Context)->Void = null;
  public final onDispose:(context:Context)->Void = null;
  final child:Child;

  function render(context:Context) {
    #if (js && !nodejs)
    var hook = Hook.from(context);
    var animation = hook.useMemo(createAnimationController, animation -> animation.dispose());
    hook.useInit(() -> {
      animation.registerAnimation(context, true);
      null;
    });
    hook.useUpdate(() -> {
      animation.registerAnimation(context, false);
      null;
    });
    hook.useCleanup(() -> {
      var element:ElementOf<Animated> = cast context;
      if (element.component.onDispose != null) {
        element.component.onDispose(context);
      }
    });
    #end

    return child;
  }
}

#if (js && !nodejs)
private function createAnimationController() {
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
#end
