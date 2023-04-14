package examples;

import pine.*;
import pine.html.*;
import eg.*;

using Nuke;

class ModalExample extends AutoComponent {
  var isOpen:Bool = false;

  function build() {
    return new Html<'div'>({
      children: [
        new Html<'button'>({
          onclick: e -> isOpen.set(true),
          children: 'Open Modal'
        }),
        new Show(isOpen, () -> new Modal({
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
          onHide: () -> isOpen.set(false),
          children: [
            new Html<'div'>({
              children: 'Hey world'
            }),
            new Scope(context -> new Html<'button'>({
              onclick: _ -> LayerContext.from(context).hide(),
              children: 'Ok'
            }))
          ]
        }))
      ]
    });
  }
}
