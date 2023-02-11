package eg;

import eg.LayerContext;
import pine.*;
import pine.html.*;

using Nuke;
using pine.Hooks;

final DefaultShowAnimation = new Keyframes('show', context -> [ { opacity: 0 }, { opacity: 1 } ]);
final DefaultHideAnimation = new Keyframes('hide', context -> [ { opacity: 1 }, { opacity: 0 } ]);

class Layer extends AutoComponent {
  final beforeShow:()->Void = null;
  final onShow:()->Void = null;
  final onHide:()->Void;
  final hideOnClick:Bool = true;
  final hideOnEscape:Bool = true;
  final child:Child;
  final transitionSpeed:Int = 150;
  final styles:ClassName = null;
  final showAnimation:Keyframes = DefaultShowAnimation;
  final hideAnimation:Keyframes = DefaultHideAnimation;

  public function render(context:Context):Component {
    context.useInit(() -> {
      if (beforeShow != null) beforeShow();
      null;
    });

    return new LayerContextProvider({
      create: () -> new LayerContext({}),
      dispose: layer -> layer.dispose(),
      render: layer -> new Scope({
        render: context -> {
          var status = layer.status;
          var body = new Html<'div'>({
            className: ClassName.ofArray([
              'eg-layer',
              styles,
              // Note: We *do* actually want to define a few 
              // styles here, as this is just how Layers work.
              Css.atoms({
                position: 'fixed',
                top: 0,
                bottom: 0,
                left: 0,
                right: 0,
                overflowX: 'hidden',
                overflowY: 'scroll',
              })
            ]),
            onclick: e -> if (hideOnClick) {
              e.preventDefault();
              layer.hide();
            },
            children: new LayerTarget({ child: child })
          });
          var animation = new Animated({
            keyframes: switch status { 
              case Showing: 
                showAnimation;
              case Hiding: 
                hideAnimation;
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

class LayerTarget extends AutoComponent {
  final child:Component;

  function render(context:Context) {
    return child;
  }
}
