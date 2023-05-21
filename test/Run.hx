import breeze.rule.Flex;
import breeze.rule.Layout;
import breeze.rule.Spacing;
import breeze.ClassName;
import js.Browser;
import pine.html.*;
import eg.PortalContext;
import pine.html.client.Client;
import examples.*;

function main() {
  mount(Browser.document.getElementById('root'), () -> new PortalContextProvider({
    value: new PortalContext(Browser.document.getElementById('portal')),
    child: portal -> new Html<'div'>({
      className: ClassName.ofArray([
        display('flex'),
        flexDirection('column'),
        gap(3),
        pad(10)
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
