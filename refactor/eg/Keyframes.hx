package eg;

import pine.Context;

using Lambda;
using Reflect;

@:forward
abstract Keyframes(Array<Keyframe>) from Array<Keyframe> to Array<Keyframe> {
  public inline function new(keyframes) {
    this = keyframes;
  }

  public inline function invert():Keyframes {
    var keyframes = this.copy();
    keyframes.reverse();
    for (frame in keyframes) {
      // @todo: Look into how to invert this. 
      frame.deleteField('offset');
    }
    return new Keyframes(keyframes);
  }

  @:to inline public function toKeyframeFactory():KeyframeFactory {
    return (conetxt:Context) -> this;
  } 
}
