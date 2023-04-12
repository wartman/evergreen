package eg;

import pine.*;

#if (js && !nodejs)
import js.Browser.window;
import js.html.Element as DomElement;
import js.html.Animation;
import js.html.Element;
import js.lib.Promise;

using Reflect;
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
    return new Setup<Animated>({
      target: context,
      setup: element -> {
        var animation = createAnimationController();
        element.events.afterInit.add((_,_) -> animation.registerAnimation(context, true));
        element.events.afterUpdate.add(_ -> animation.registerAnimation(context, false));
        element.events.beforeDispose.add(_ -> {
          if (element.component.onDispose != null) {
            element.component.onDispose(context);
          }
          animation.dispose();
        });
      },
      child: child
    });
    #else
    return child;
    #end

  }
}

#if (js && !nodejs)
private typedef AnimationOptions = {
  public final duration:Int;
  public final ?easing:String;
  public final ?iterations:Float;
}

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

    currentAnimation = registerAnimations(el, keyframes.create(element), {
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

private function registerAnimations(el:Element, keyframes:Array<Dynamic>, options:AnimationOptions, onFinished:()->Void):Animation {
  var duration = prefersReducedMotion() ? 0 : options.duration;
  var animation = el.animate(keyframes, { 
    duration: duration,
    easing: options.easing,
    iterations: options.iterations
  });
  
  // @todo: I don't think we want to trigger finished if we're canceling.
  // animation.addEventListener('cancel', onFinished, { once: true });
  animation.addEventListener('finish', onFinished, { once: true });

  return animation;
}

private function stopAnimations(el:Element, onFinished:()->Void) {
  kit.Task.parallel(...el.getAnimations().map(animation -> new kit.Task(activate -> {
    animation.addEventListener('cancel', () -> activate(Ok(null)), { once: true });
    animation.addEventListener('finish', () -> activate(Ok(null)), { once: true });
    animation.cancel();
  }))).handle(_ -> onFinished());

  // Promise.all(el.getAnimations().map(animation -> {
  //   return new Promise((res, _) -> {
  //     animation.addEventListener('cancel', () -> res(null), { once: true });
  //     animation.addEventListener('finish', () -> res(null), { once: true });
  //     animation.cancel();
  //   });
  // })).finally(onFinished);
}

private function prefersReducedMotion() {
  var query = window.matchMedia('(prefers-reduced-motion: reduce)');
  return query.matches;
}
#end
