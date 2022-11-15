package eg;

import pine.*;
import pine.html.*;
import eg.LayerContext;

using Nuke;

class Layer extends ImmutableComponent {
  @prop final beforeShow:()->Void = null;
  @prop final onShow:()->Void = null;
  @prop final onHide:()->Void;
  @prop final hideOnClick:Bool = true;
  @prop final hideOnEscape:Bool = true;
  @prop final child:HtmlChild;
  @prop final transitionSpeed:Int = 150;
  @prop final styles:ClassName = null;
  @prop final showAnimation:Keyframes = [ { opacity: 0 }, { opacity: 1 } ];
  @prop final hideAnimation:Keyframes = null;

  override function init(context:InitContext) {
    if (beforeShow != null) beforeShow();
  }

  public function render(context:Context):Component {
    return new LayerContextProvider({
      create: () -> new LayerContext({}),
      dispose: layer -> layer.dispose(),
      render: layer -> new Isolate({
        wrap: _ -> {
          var status = layer.status;
          var body = new DynamicComponent({
            styles: [
              'eg-layer',
              styles
            ],
            onclick: e -> if (hideOnClick) {
              e.preventDefault();
              layer.hide();
            },
            children: new LayerTarget({ child: child })
          });
          var animation = new Animated({
            createKeyframes: switch status { 
              case Showing: showAnimation;
              case Hiding: hideAnimation == null
                ? showAnimation.invert()
                : hideAnimation;
            },
            duration: transitionSpeed,
            onFinished: _ -> switch status {
              case Showing:
                if (onShow != null) onShow();
              case Hiding:
                if (onHide != null) onHide();
            },
            onDispose: _ -> if (onHide != null) onHide(),
            child: body
          });

          return new LayerContainer({
            hideOnEscape: hideOnEscape,
            child: animation
          });
        }
      })
    });
  }
}
