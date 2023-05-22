package examples;

import eg.*;
import pine.*;
import pine.html.*;

using Breeze;

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
          Background.color('red', 500),
          Sizing.height('30px'),
          Sizing.width('30px')
        ])
      })
    });
  }
}
