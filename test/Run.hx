import js.Browser;
import pine.html.*;
import eg.PortalContext;
import pine.html.client.Client;
import examples.*;

using Breeze;

function main() {
  mount(Browser.document.getElementById('root'), () -> new PortalContextProvider({
    value: new PortalContext(Browser.document.getElementById('portal')),
    child: portal -> new Html<'div'>({
      className: ClassName.ofArray([
        Flex.display(),
        Flex.direction('column'),
        Flex.gap(3),
        Spacing.pad(10)
      ]),
      children: [
        new DropdownExample({}),
        new ModalExample({}),
        new CollapseExample({}),
        new AnimatedExample({})
      ]
    })
  }));
}
