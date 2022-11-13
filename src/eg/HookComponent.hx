package eg;

import pine.*;

@:autoBuild(eg.HookComponentBuilder.build())
abstract class HookComponent extends Component {
  abstract public function getChild():Component;
}
