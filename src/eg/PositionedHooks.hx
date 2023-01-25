package eg;

import eg.CoreHooks;
import pine.*;

function usePosition(context:Context) {
  var hook:Hook<Positioned> = Hook.from(context);
  var positionElement = hook.useData(() -> createElementPositioner(context));
  useWindowEvent(context, 'resize', (_, _) -> positionElement());
  useWindowEvent(context, 'scroll', (_, _) -> positionElement());
  hook.useInit(() -> {
    var el:js.html.Element = context.getObject();
    el.style.position = 'fixed';
    el.style.zIndex = '9000'; // @todo: Figure out a universal zIndex api
    positionElement();
  });
  hook.useUpdate(() -> positionElement());
}

private function createElementPositioner(element:ElementOf<Positioned>) return function () {
  var positioned = element.component;
  var el:js.html.Element = element.getObject();
  var target:js.html.Element = positioned.getTarget();
  var targetRect = target.getBoundingClientRect();
  var container = getContainerSize();
  var vAttachment = positioned.attachment.v;
  var hAttachment = positioned.attachment.h;

  var top = switch vAttachment {
    case Top: 
      (targetRect.top) - el.offsetHeight;
    case Bottom: 
      targetRect.bottom;
    case Middle: 
      (targetRect.top) 
        + (target.offsetHeight / 2) 
        - (el.offsetHeight / 2);
  }
  var left = switch hAttachment {
    case Right: 
      targetRect.right;
    case Left: 
      (targetRect.left) - el.offsetWidth;
    case Middle:
      (targetRect.left)
        + (target.offsetWidth / 2)
        - (el.offsetWidth / 2);
  }

  if (overflowsVertical(top, el.offsetHeight)) top = switch vAttachment {
    case Top if (top > 0):
      container.bottom - el.offsetHeight;
    case Top:
      0;
    case Bottom if (top > 0):
      (targetRect.top) - el.offsetHeight;
    case Bottom:
      0;
    case Middle if (top > 0):
      targetRect.top;
    case Middle:
      0;
  }

  if (overflowsHorizontal(left, el.offsetWidth)) left = switch hAttachment {
    case Right:
      (targetRect.right) - el.offsetWidth;
    case Left:
      0;
    case Middle if (left > 0):
      (targetRect.right) - el.offsetWidth;
    case Middle:
      0;
  }

  el.style.top = '${top}px';
  el.style.left = '${left}px';
}

private function getContainerSize():{ 
  top:Float,
  bottom:Float,
  left:Float, 
  right:Float 
} {
  return {
    left: 0,
    top: 0,
    bottom: js.Browser.window.outerHeight,
    right: js.Browser.window.outerWidth
  };
}

private function overflowsVertical(top:Float, height:Float) {
  return top < 0 || top + height >= getContainerSize().bottom;
}

private function overflowsHorizontal(left:Float, width:Float) {
  return left < 0 || left + width >= getContainerSize().right;
}
