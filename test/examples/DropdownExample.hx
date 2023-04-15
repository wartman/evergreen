package examples;

import pine.*;
import pine.html.*;
import pine.html.HtmlEvents;
import eg.*;

using Nuke;

class DropdownExample extends AutoComponent {
  function build() {
    return new Html<'div'>({
      children: [
        new Dropdown({
          toggle: dropdown -> new Html<'button'>({
            onclick: e -> {
              e.preventDefault();
              e.stopPropagation();
              dropdown.toggle();
            },
            children: [
              dropdown.status.map(status -> switch status {
                case Open: 'Close Dropdown';
                case Closed: 'Open Dropdown';
              })
            ]
          }),
          body: _ -> new Html<'ul'>({
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

class ExampleDropdownItem extends AutoComponent {
  final child:Child;
  final onClick:EventListener;

  function build() {
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
        // the Dropdown will NOT be accessible if you don't 
        // use DropdownItems.
        new DropdownItem({
          child: new Html<'a'>({
            onclick: e -> {
              e.preventDefault();
              // Note: Something like this is required to
              // auto-close the dropdown when an option is 
              // selected.
              DropdownContext.from(this).close();
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
