package examples;

import breeze.rule.Layout.layer;
import breeze.rule.Filter.dropShadow;
import breeze.ClassName;
import breeze.rule.Sizing;
import breeze.rule.Background;
import breeze.rule.Border;
import breeze.rule.Spacing;
import eg.*;
import pine.*;
import pine.html.*;
import pine.html.HtmlEvents;
import system.Button;
import system.Panel;

class DropdownExample extends AutoComponent {
  function build() {
    return new Html<'div'>({
      children: [
        new Dropdown({
          toggle: dropdown -> new Button({
            action: e -> {
              e.preventDefault();
              e.stopPropagation();
              dropdown.toggle();
            },
            label: dropdown.status.map(status -> switch status {
              case Open: 'Close Dropdown';
              case Closed: 'Open Dropdown';
            })
          }),
          child: _ -> new Panel({
            styles: ClassName.ofArray([
              bgColor('white', 0),
              width('min', '50px'),
              layer(10),
              dropShadow('xl')
            ]),
            children: new Html<'ul'>({
              onClick: e -> e.stopPropagation(),
              className: pad(1),
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
            onClick: e -> {
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
