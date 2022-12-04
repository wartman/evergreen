package eg.xml;

import haxe.macro.Context;
import haxe.macro.Expr;

using haxe.macro.Tools;

function parseExpr(expr:Expr) {
  return switch expr.expr {
    case EConst(CString(s, _)):
      parse(s, expr.pos);
    default:
      Context.error('Expected a string', expr.pos);
      macro null;
  }
}

function parse(str:String, pos:Position):Expr {
  var node = Xml.parse(str);
  var components = generate(node, false, pos);
  
  if (components.length > 1 || components.length == 0) {
    return macro new pine.Fragment({ children: [ $a{components} ] });
  }
  return components[0];
}

function generate(nodes:Xml, isSvg:Bool = false, pos:Position):Array<Expr> {
  return [ for (node in nodes) switch node.nodeType {
    case Element:
      var name = switch node.nodeName.split(':') {
        case ['svg', name]: 
          isSvg = true;
          name;
        default: 
          node.nodeName;
      };
      var attrs:Array<ObjectField> = [ for (attr in node.attributes()) {
        field: attr,
        expr: macro $v{node.get(attr)}
      } ];
      attrs.push({
        field: 'children',
        expr: macro [ $a{generate(node, isSvg, pos)} ] 
      });
      var ct = name.toComplex();
      var path:TypePath = {
        pack: ['pine', 'html'],
        name: isSvg ? 'Svg' : 'Html',
        params: [ TPExpr(macro $v{name}) ]
      };

      macro new $path(${ {
        expr: EObjectDecl(attrs),
        pos: pos
      } });
    case PCData if (!isSvg):
      var text = node.nodeValue;
      macro ($v{text}:pine.html.HtmlChild);
    default: null;
  } ].filter(n -> n != null);
}
