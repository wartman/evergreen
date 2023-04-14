package examples;

import pine.*;
import pine.html.*;
import eg.*;

using Nuke;

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
        className: Css.atoms({
          background: 'black',
          height: 30.px(),
          width: 30.px()
        })
      })
    });
  }
}
