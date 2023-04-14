package eg;

import eg.CollapseContext;
import pine.*;

using Kit;

class Collapse extends AutoComponent {
  final child:Child;
  final initialStatus:CollapseContextStatus = Collapsed;
  final duration:Int = 200;

  function build() {
    return new CollapseContextProvider({
      create: () -> {
        var collapse = new CollapseContext({ 
          status: initialStatus,
          duration: duration
        });
        AccordionContext
          .maybeFrom(this)
          .ifExtract(Some(accordion), accordion.add(collapse));
        return collapse;
      },
      dispose: collapse -> {
        AccordionContext
          .maybeFrom(this)
          .ifExtract(Some(accordion), accordion.remove(collapse));
        // collapse.dispose();
      },
      build: _ -> child 
    });
  }
}
