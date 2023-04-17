package eg;

import pine.*;

#if (js && !nodejs)
import js.Browser.window;
import js.html.Animation;
import js.html.Element;

using Reflect;
#end

class Animated extends AutoComponent {
  @:observable public final keyframes:Keyframes;
  public final dontAnimateInitial:Bool = false;
  public final dontRepeatCurrentAnimation:Bool = true;
  public final duration:Int;
  public final infinite:Bool = false;
  public final easing:String = 'linear';
  public final onFinished:(context:Component)->Void = null;
  public final onDispose:(context:Component)->Void = null;
  final child:Child;

  function build() {
    #if (js && !nodejs)
    var first = true;
    addEffect(() -> {
      registerAnimation(first);
      first = false;
      return () -> if (currentAnimation != null) {
        currentAnimation.cancel();
        currentAnimation = null;
      }
    });
    addDisposable(() -> {
      if (onDispose != null) onDispose(this);
    });
    #end
    return child;
  }

  #if (js && !nodejs)
  var currentKeyframes:Null<Keyframes> = null;
  var currentAnimation:Null<Animation> = null;

  function registerAnimation(first:Bool = false) {
    if (isComponentDisposing() || isComponentDisposed()) return;

    var el:Element = getObject();
    var duration = if (first && dontAnimateInitial) 0 else duration;
    var keyframes = keyframes();

    if (dontRepeatCurrentAnimation) {
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
      if (this.onFinished != null) this.onFinished(this);
    }

    currentAnimation = registerAnimations(el, keyframes.create(this), {
      duration: duration,
      easing: easing,
      iterations: if (infinite) Math.POSITIVE_INFINITY else 1
    }, onFinished);
  }
  #end
}

#if (js && !nodejs)
private typedef AnimationOptions = {
  public final duration:Int;
  public final ?easing:String;
  public final ?iterations:Float;
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
