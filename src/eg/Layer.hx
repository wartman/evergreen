package eg;

import eg.LayerContext;
import pine.*;
import pine.html.*;

final DefaultShowAnimation = new Keyframes('show', context -> [ { opacity: 0 }, { opacity: 1 } ]);
final DefaultHideAnimation = new Keyframes('hide', context -> [ { opacity: 1 }, { opacity: 0 } ]);

class Layer extends AutoComponent {
  final onShow:()->Void = null;
  final onHide:()->Void;
  final hideOnClick:Bool = true;
  final hideOnEscape:Bool = true;
  final child:Child;
  final transitionSpeed:Int = 150;
  final styles:String = null;
  final showAnimation:Keyframes = DefaultShowAnimation;
  final hideAnimation:Keyframes = DefaultHideAnimation;

  public function build() {
    return new LayerContextProvider({
      value: new LayerContext({}),
      child: layer -> {
        var body = new Html<'div'>({
          className: [ 'eg-layer', styles ].filter(s -> s != null).join(' '),
          style: 'position:fixed;inset:0px;overflow-x:hidden;overflow-y:scroll;',
          onClick: e -> if (hideOnClick) {
            e.preventDefault();
            layer.hide();
          },
          children: new LayerTarget({ child: child })
        });
        var animation = new Animated({
          keyframes: layer.status.map(status -> switch status { 
            case Showing: 
              showAnimation;
            case Hiding: 
              hideAnimation;
          }),
          duration: transitionSpeed,
          onFinished: _ -> switch layer.status.peek() {
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
    });
  }
}

class LayerTarget extends AutoComponent {
  final child:Component;

  function build() {
    return child;
  }
}
