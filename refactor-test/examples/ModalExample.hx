package examples;

import pine.*;
import pine.html.*;
import eg.*;

using Nuke;

class ModalExample extends AutoComponent {
  @:track var isOpen:Bool = false;

  function render(context:Context) {
    return new Html<'div'>({
      children: [
        new Html<'button'>({
          onclick: e -> isOpen = true,
          children: 'Open Modal'
        }),
        if (isOpen) new Modal({
          styles: Css.atoms({
            padding: 1.em(),
            background: rgb(255, 255, 255),
            width: 250.px(),
            border: [ 1.px(), 'solid', rgb(0, 0, 0) ]
          }),
          layerStyles: Css.atoms({
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            backgroundColor: rgba(0, 0, 0, 0.5)
          }),
          onHide: () -> isOpen = false,
          children: [
            new Html<'div'>({
              children: 'Hey world'
            }),
            new Scope({
              render: context -> new Html<'button'>({
                // Note: We do this instead of `isOpen = false` to 
                // let the Layer handle hiding itself. This ensures,
                // among other things, that the hide animation 
                // plays.
                onclick: _ -> LayerContext.from(context).hide(),
                children: 'Ok'
              }) 
            })
          ]
        }) else null
      ]
    });
  }
}
