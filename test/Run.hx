import js.Browser;
import pine.html.*;
import eg.PortalContext;
import pine.html.client.Client;
import examples.*;

function main() {
  mount(Browser.document.getElementById('root'), () -> new PortalContextProvider({
    value: new PortalContext(Browser.document.getElementById('portal')),
    build: portal -> new Html<'div'>({
      children: [
        new DropdownExample({}),
        new ModalExample({}),
        new CollapseExample({}),
        new AnimatedExample({})
      ]
    })
  }));
}
