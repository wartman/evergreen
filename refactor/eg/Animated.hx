package eg;

import pine.*;
import pine.html.*;

#if (js && !nodejs)
@:hook(element -> new AnimatedController(element))
#end
class Animated extends AutoComponent {
  public final dontAnimateInitial:Bool = false;
  public final createKeyframes:KeyframeFactory;
  public final duration:Int;
  public final infinite:Bool = false;
  public final easing:String = 'linear';
  public final onFinished:(context:Context)->Void = null;
  public final onDispose:(context:Context)->Void = null;
  final child:HtmlChild;

  function render(context:Context) {
    return child;
  }
}
