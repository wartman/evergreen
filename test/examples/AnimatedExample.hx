package examples;

import breeze.ClassName;
import breeze.rule.Background;
import breeze.rule.Sizing;
import eg.*;
import pine.*;
import pine.html.*;

class AnimatedExample extends AutoComponent {
  function build() {
    return new Animated({
      keyframes: new Keyframes('auto', _ ->  [
        { transform: 'rotate(0)' },
        { transform: 'rotate(360deg)' }
      ]),
      duration: 1000,
      infinite: true,
      onFinished: _ -> trace('ok'),
      child: new Html<'div'>({
        className: ClassName.ofArray([
          bgColor('black', 0),
          height('30px'),
          width('30px')
        ])
      })
    });
  }
}
