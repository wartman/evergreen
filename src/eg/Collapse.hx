package eg;

import eg.CollapseContext;
import pine.*;

using Kit;

class Collapse extends AutoComponent {
  final child:Child;
  final initialStatus:CollapseContextStatus = Collapsed;
  final duration:Int = 200;

  function build() {
    var collapse = new CollapseContext({ 
      status: initialStatus,
      duration: duration
    });
    AccordionContext
      .maybeFrom(this)
      .ifExtract(Some(accordion), accordion.add(collapse));

    return new CollapseContextProvider({
      value: collapse,
      dispose: collapse -> {
        AccordionContext
          .maybeFrom(this)
          .ifExtract(Some(accordion), accordion.remove(collapse));
        collapse.dispose();
      },
      child: _ -> child 
    });
  }
}
