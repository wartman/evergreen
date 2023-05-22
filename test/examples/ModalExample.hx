package examples;

import eg.*;
import pine.*;
import pine.html.*;
import system.Button;

using Breeze;

class ModalExample extends AutoComponent {
  @:signal final isOpen:Bool = false;

  function build() {
    return new Html<'div'>({
      children: [
        new Button({
          priority: Primary,
          action: _ -> isOpen.set(true),
          label: 'Open Modal'
        }),
        new Show(isOpen, () -> new Modal({
          styles: ClassName.ofArray([
            Background.color('white', 0),
            Sizing.width('250px'),
            Border.radius(2),
            Border.color('black', 0),
            Border.width(.5),
            Spacing.pad(4),
          ]),
          layerStyles: Flex.display()
            .with(Flex.alignItems('center'))
            .with(Flex.justify('center'))
            .with(Background.color('rgba(0,0,0,0.5)')),
          onHide: () -> isOpen.set(false),
          children: [
            new Html<'div'>({
              className: Spacing.pad('bottom', 4),
              children: 'Hey world'
            }),
            new Scope(context -> new Button({
              action: _ -> LayerContext.from(context).hide(),
              label: 'Ok'
            }))
          ]
        }))
      ]
    });
  }
}
