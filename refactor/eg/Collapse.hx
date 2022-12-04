package eg;

import pine.*;
import pine.html.*;
import eg.CollapseContext;

using pine.core.OptionTools;

class Collapse extends AutoComponent {
  final child:HtmlChild;
  final duration:Int = 200;

  function render(context:Context) {
    return new CollapseContextProvider({
      create: () -> {
        var collapse = new CollapseContext({ 
          status: Collapsed,
          duration: duration
        });
        AccordianContext
          .maybeFrom(context)
          .some(accordian -> accordian.add(collapse));
        return collapse;
      },
      dispose: collapse -> {
        AccordianContext
          .maybeFrom(context)
          .some(accordian -> accordian.remove(collapse));
        collapse.dispose();
      },
      render: _ -> child 
    });
  }
}
