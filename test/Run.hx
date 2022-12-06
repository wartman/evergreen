import js.Browser;
import pine.html.*;
import eg.PortalContext;
import pine.html.client.ClientRoot;
import examples.*;

function main() {
  ClientRoot.mount(Browser.document.getElementById('root'), new PortalContextProvider({
    create: () -> new PortalContext(Browser.document.getElementById('portal')),
    dispose: portal -> portal.dispose(),
    render: portal -> new Html<'div'>({
      children: [
        new DropdownExample({}),
        new ModalExample({}),
        new CollapseExample({}),
        new AnimatedExample({})
      ]
    })
  }));
}
