package examples;

import pine.*;
import pine.html.*;
import pine.html.HtmlEvents;
import eg.*;

using Nuke;

class DropdownExample extends ImmutableComponent {
  function render(context:Context) {
    return new Html<'div'>({
      children: [
        new Dropdown({
          label: 'A dropdown',
          child: new Html<'ul'>({
            onclick: e -> e.stopPropagation(),
            className: Css.atoms({
              padding: 1.em(),
              background: rgb(255, 255, 255),
              border: [ 1.px(), 'solid', rgb(0, 0, 0) ]
            }),
            children: [
              new ExampleDropdownItem({
                onClick: _ -> trace('one'),
                child: 'One'
              }),
              new ExampleDropdownItem({
                onClick: _ -> trace('two'),
                child: 'Two'
              }),
              new ExampleDropdownItem({
                onClick: _ -> trace('three'),
                child: 'Three'
              }),
            ]
          })
        })
      ]
    });
  }
}

class ExampleDropdownItem extends ImmutableComponent {
  @prop final child:HtmlChild;
  @prop final onClick:EventListener;

  function render(context:Context) {
    return new Html<'li'>({
      children: [
        new DropdownItem({
          child: new Html<'a'>({
            onclick: e -> {
              e.preventDefault();
              DropdownContext.from(context).close();
              onClick(e);
            },
            href: '#',
            children: [ child ]
          })
        })
      ]
    });
  }
}
