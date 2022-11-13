package eg;

enum abstract FadeKind(Bool) {
  final In = false;
  final Out = true;
}

function fade(kind:FadeKind):Keyframes {
  return switch kind {
    case In: [ { opacity: 0 }, { opacity: 1 } ];
    case Out: [ { opacity: 1 }, { opacity: 0 } ]; 
  }
}

// @todo: more
