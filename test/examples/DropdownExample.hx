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
          label: 'Open dropdown',
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
        // Note: `DropdownItem` is just a marker component, used by the
        // Dropdown to figure out what items it can focus on when using
        // keyboard controls. For that reason, `DropdownItem` should
        // be as close as possible to the actual `ObjectComponent`
        // (`Html<'a'>`, in this case -- note how we *didn't* put
        // it earlier, around `Html<'li'>`), *and* that component
        // should create a focusable html element (that is, an
        // `<a>` element with a "href", a `<button>`, etc). Note that
        // the Dropdown will NOT be accessable if you don't 
        // use DropdownItems.
        new DropdownItem({
          child: new Html<'a'>({
            onclick: e -> {
              e.preventDefault();
              // Note: Something like this is required to
              // auto-close the dropdown when an option is 
              // selected.
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
