package eg;

import pine.*;
import pine.html.*;
import eg.CollapseContext;

class Collapse extends AutoComponent {
  @:prop final child:HtmlChild;
  @:prop final duration:Int = 200;

  function render(context:Context) {
    return new CollapseContextProvider({
      create: () -> {
        var collapse = new CollapseContext({ 
          status: Collapsed,
          duration: duration
        });
        switch AccordianContext.maybeFrom(context) {
          case Some(accordian): accordian.add(collapse);
          case None:
        }
        return collapse;
      },
      dispose: collapse -> {
        switch AccordianContext.maybeFrom(context) {
          case Some(accordian): accordian.remove(collapse);
          case None:
        }
        collapse.dispose();
      },
      render: _ -> child 
    });
  }
}