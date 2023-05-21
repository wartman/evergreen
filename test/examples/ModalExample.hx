package examples;

import breeze.rule.Background;
import breeze.rule.Border;
import breeze.rule.Flex;
import breeze.rule.Layout;
import breeze.rule.Sizing;
import breeze.rule.Spacing;
import eg.*;
import pine.*;
import pine.html.*;

class ModalExample extends AutoComponent {
  @:signal final isOpen:Bool = false;

  function build() {
    return new Html<'div'>({
      children: [
        new Html<'button'>({
          onClick: e -> isOpen.set(true),
          children: 'Open Modal'
        }),
        new Show(isOpen, () -> new Modal({
          styles: pad(1)
            .with(bgColor('white', 0))
            .with(width('250px'))
            .with(borderWidth(1))
            .with(borderStyle('solid'))
            .with(borderColor('black', 0)),
          layerStyles: display('flex')
            .with(alignItems('center'))
            .with(justify('center'))
            .with(bgColor('rgba(0,0,0,0.5)')),
          onHide: () -> isOpen.set(false),
          children: [
            new Html<'div'>({
              children: 'Hey world'
            }),
            new Scope(context -> new Html<'button'>({
              onClick: _ -> LayerContext.from(context).hide(),
              children: 'Ok'
            }))
          ]
        }))
      ]
    });
  }
}
