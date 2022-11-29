package examples;

import pine.*;
import pine.html.*;
import eg.*;

using Nuke;

class CollapseExample extends ImmutableComponent {
  function render(context:Context) {
    return new Collapse({
      child: new Html<'div'>({
        className: Css.atoms({
          backgroundColor: '#ccc'
        }),
        children: [
          new ExampleCollapseHeader({ child: 'Collapse' }),
          new ExampleCollapseBody({
            children: new Html<'p'>({ children: 'Some stuff' })
          })
        ]
      })
    });
  }
}

class ExampleCollapseHeader extends ImmutableComponent {
  @prop final child:HtmlChild;

  function render(context:Context) {
    var collapse = CollapseContext.from(context);

    return new Html<'button'>({
      onclick: _ -> collapse.toggle(),
      children: new Isolate({
        // `collapse.status` is a State, so we can observe it
        // for changes. In a real implementation, this might be
        // where you have a chevron icon rotate or otherwise
        // indicate a collapsed/expanded status.
        wrap: _ -> switch collapse.status {
          case Collapsed: new Fragment({ children: [ child, (' +':HtmlChild) ] });
          case Expanded: new Fragment({ children: [ child, (' -':HtmlChild) ] });
        }
      })
    });
  }
}

class ExampleCollapseBody extends ImmutableComponent {
  @prop final children:HtmlChildren;

  function render(context:Context) {
    return new CollapseItem({
      child: new Html<'div'>({
        className: Css.atoms({
          // Note: Setting overflow to 'hidden' is required for 
          // the Collapse to work properly.
          overflow: 'hidden',
          // Also setting box-sizing to `border-box` will make things
          // work much better, as the padding will be included in
          // when the Component calculates the size of the element.
          boxSizing: 'border-box'
        }),
        children: new Html<'div'>({
          className: Css.atoms({
            // Note that we do NOT put the padding in the
            // main collapse target, as this will result in the collapsed
            // element still being visible even if its hieght is `0`.
            padding: 15.px()
          }),
          children: children
        })
      })
    });
  }
}
