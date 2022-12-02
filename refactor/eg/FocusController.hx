package eg;

import pine.*;

class FocusController implements Controller<Component> {
  final getTargetObject:(element:Element)->js.html.Element;

  public function new(getTargetObject) {
    this.getTargetObject = getTargetObject;
  }

  public function register(element:ElementOf<Component>) {
    element.addHook({
      afterInit: element -> {
        FocusContext.from(element).focus(getTargetObject(element));
      },
      onDispose: element -> {
        FocusContext.from(element).returnFocus();
      }
    });
  }
  
  public function dispose() {}
}
