package eg;

import pine.macro.ImmutablePropertyBuilder;

using Lambda;
using pine.macro.MacroTools;

function build() {
  var fields = MacroTools.getBuildFieldsSafe();
  var builder = new ImmutablePropertyBuilder(fields);

  builder.addProp(MacroTools.makeField('key', macro:pine.Key, true));
  builder.addProp(MacroTools.makeField('child', macro:pine.Component, false));

  var propsType = builder.getPropsType();

  builder.add(macro class {
    public static final componentType = new pine.UniqueId();
    final child:pine.Component;

    public function new(props:$propsType) {
      super(props.key);
      this.child = props.child;
      ${builder.getInitializers()}
    }

    function getComponentType() {
      return componentType;
    }

    function getChild() {
      return child;
    }
  });

  return builder.export();
}
