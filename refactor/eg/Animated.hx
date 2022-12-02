package eg;

import pine.*;
import pine.html.*;

#if (js && !nodejs)
@:controller(new AnimatedLifecycleController())
#end
class Animated extends AutoComponent {
  @:prop public final dontAnimateInitial:Bool = false;
  @:prop public final createKeyframes:KeyframeFactory;
  @:prop public final duration:Int;
  @:prop public final infinite:Bool = false;
  @:prop public final easing:String = 'linear';
  @:prop public final onFinished:(context:Context)->Void = null;
  @:prop public final onDispose:(context:Context)->Void = null;
  @:prop final child:HtmlChild;

  function render(context:Context) {
    return child;
  }
}
