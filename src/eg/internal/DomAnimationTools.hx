package eg.internal;

import js.Browser.window;
import js.html.Element;
import js.html.Animation;
import js.lib.Promise;

using Reflect;

function registerAnimations(el:Element, keyframes:Array<Dynamic>, duration:Int, onFinished:()->Void):Animation {
  var duration = prefersReducedMotion() ? 0 : duration;
  var animation = el.animate(keyframes, { duration: duration });
  
  // @todo: I don't think we want to trigger finished if we're canceling.
  // animation.addEventListener('cancel', onFinished, { once: true });
  animation.addEventListener('finish', onFinished, { once: true });

  return animation;
}

function stopAnimations(el:Element, onFinished:()->Void) {
  Promise.all(el.getAnimations().map(animation -> {
    return new Promise((res, _) -> {
      animation.addEventListener('cancel', () -> res(null), { once: true });
      animation.addEventListener('finish', () -> res(null), { once: true });
      animation.cancel();
    });
  })).finally(onFinished);
}

function prefersReducedMotion() {
  var query = window.matchMedia('(prefers-reduced-motion: reduce)');
  return query.matches;
}
