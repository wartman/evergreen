package eg;

import pine.*;

using Lambda;
using Reflect;

class Keyframes {
  public final id:String;
  public final factory:(context:Component) -> Array<{}>;

  public function new(id, factory) {
    this.id = id;
    this.factory = factory;
  }

  public function equals(other:Keyframes) {
    return id == other.id;
  }

  public function create(context) {
    return factory(context);
  }
}
