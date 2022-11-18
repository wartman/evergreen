package eg.xml;

macro function toComponent(expr) {
  return eg.xml.XmlParser.parseExpr(expr);
}
