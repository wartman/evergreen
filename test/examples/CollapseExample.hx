package examples;

import pine.*;
import pine.html.*;
import eg.*;

using Nuke;

class CollapseExample extends AutoComponent {
  function build() {
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

class ExampleCollapseHeader extends AutoComponent {
  final child:Child;

  function build() {
    var collapse = CollapseContext.from(this);

    return new Html<'button'>({
      onclick: _ -> collapse.toggle(),
      // `collapse.status` is a State, so we can observe it
      // for changes. In a real implementation, this might be
      // where you have a chevron icon rotate or otherwise
      // indicate a collapsed/expanded status.
      children: [
        child,
        new Text(compute(() -> switch collapse.status() {
          case Collapsed: ' +';
          case Expanded: ' -';
        }))
      ]
    });
  }
}

class ExampleCollapseBody extends AutoComponent {
  final children:Children;

  function build() {
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
            // element still being visible even if its height is `0`.
            padding: 15.px()
          }),
          children: children
        })
      })
    });
  }
}
