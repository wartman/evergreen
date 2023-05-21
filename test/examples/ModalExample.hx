package examples;

import breeze.ClassName;
import breeze.rule.Background;
import breeze.rule.Border;
import breeze.rule.Flex;
import breeze.rule.Layout;
import breeze.rule.Sizing;
import breeze.rule.Spacing;
import eg.*;
import pine.*;
import pine.html.*;
import system.Button;

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
            bgColor('white', 0),
            width('250px'),
            borderRadius(2),
            borderColor('black', 0),
            borderWidth(.5),
            pad(4),
          ]),
          layerStyles: display('flex')
            .with(alignItems('center'))
            .with(justify('center'))
            .with(bgColor('rgba(0,0,0,0.5)')),
          onHide: () -> isOpen.set(false),
          children: [
            new Html<'div'>({
              className: ClassName.ofArray([
                pad('bottom', 4),
              ]),
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
