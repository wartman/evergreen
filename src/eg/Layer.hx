package eg;

import eg.LayerContext;
import pine.*;
import pine.html.*;

using Nuke;

final DefaultShowAnimation = new Keyframes('show', context -> [ { opacity: 0 }, { opacity: 1 } ]);
final DefaultHideAnimation = new Keyframes('hide', context -> [ { opacity: 1 }, { opacity: 0 } ]);

class Layer extends AutoComponent {
  final onShow:()->Void = null;
  final onHide:()->Void;
  final hideOnClick:Bool = true;
  final hideOnEscape:Bool = true;
  final child:Child;
  final transitionSpeed:Int = 150;
  final styles:ClassName = null;
  final showAnimation:Keyframes = DefaultShowAnimation;
  final hideAnimation:Keyframes = DefaultHideAnimation;

  public function build() {
    return new LayerContextProvider({
      value: new LayerContext({}),
      build: layer -> {
        var body = new Html<'div'>({
          // @todo: Consider if we actually want this dependency
          // on Nuke in here. It might be OK if the layer has 
          // no classes.
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
