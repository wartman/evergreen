package eg;

import eg.CollapseContext;
import pine.*;

using pine.core.OptionTools;

class Collapse extends AutoComponent {
  final child:Child;
  final initialStatus:CollapseContextStatus = Collapsed;
  final duration:Int = 200;

  function render(context:Context) {
    return new CollapseContextProvider({
      create: () -> {
        var collapse = new CollapseContext({ 
          status: initialStatus,
          duration: duration
        });
        AccordionContext
          .maybeFrom(context)
          .some(accordion -> accordion.add(collapse));
        return collapse;
      },
      dispose: collapse -> {
        AccordionContext
          .maybeFrom(context)
          .some(accordion -> accordion.remove(collapse));
        collapse.dispose();
      },
      render: _ -> child 
    });
  }
}
