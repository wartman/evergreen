package eg;

import pine.*;

enum abstract KeyModifier(String) from String to String {
  final Alt;
  final CapsLock;
  final Control;
  final Fn;
  final FnLock;
  final Hyper;
  final Meta;
  final NumLock;
  final ScrollLock;
  final Shift;
  final Super;
  final Symbol;
  final SymbolLock;
}

enum abstract KeyType(String) from String {
  final Alt;
  final CapsLock;
  final Control;
  final Fn;
  final FnLock;
  final Hyper;
  final Meta;
  final NumLock;
  final ScrollLock;
  final Shift;
  final Super;
  final Symbol;
  final SymbolLock;
  final Escape;
  final Enter;
  final Tab;
  final Space = ' ';
  final ArrowDown;
  final ArrowUp;
  final ArrowLeft;
  final ArrowRight;
  final End;
  final Home;
  final PageDown;
  final PageUp;
  final Backspace;
  // @todo: Add the rest of this stuff
}

class KeyboardInput extends AutoComponent {
  final child:Child;
  final preventDefault:Bool = true;
  final handler:(key:KeyType, getModifierState:(modifier:KeyModifier)->Bool)->Void;

  function render(context:Context) {
    return new Proxy<KeyboardInput>({
      target: context,
      setup: element -> {
        #if (js && !nodejs)
        element.onInit(() -> {
          var el:js.html.Element = element.getObject();
          var document = el.ownerDocument;

          function listener(e:js.html.KeyboardEvent) {
            if (preventDefault) e.preventDefault();
            handler(e.key, (key:KeyModifier) -> e.getModifierState(key));
          }

          document.addEventListener('keydown', listener);
          return () -> document.removeEventListener('keydown', listener);
        });
        #end
      },
      child: child
    });
  }
}