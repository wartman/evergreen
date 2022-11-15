import js.Browser;
import pine.html.*;
import eg.PortalContext;
import pine.html.dom.DomBootstrap;
import examples.*;

function main() {
  var boot = new DomBootstrap(Browser.document.getElementById('root'));
  boot.mount(new PortalContextProvider({
    create: () -> new PortalContext(Browser.document.getElementById('portal')),
    dispose: portal -> portal.dispose(),
    render: portal -> new Html<'div'>({
      children: [
        new DropdownExample({})
      ]
    })
  }));
}
