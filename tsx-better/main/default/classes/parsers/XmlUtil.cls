/**
 * @author Timothy Sinard
 *
 */
public class XmlUtil {

    public static String convertXmlToJson(String xml) {
        return JSON.serialize(XmlUtil.parse(xml));
    }

    public static Map<String, Object> parse(String xml) {
        Dom.Document asDoc = new Dom.Document();
        asDoc.load(xml);
        return parse(asDoc.getRootElement());
    }
    public static Map<String, Object> parse(Dom.XmlNode node) {

        Map<String, Object> structured = new Map<String, Object>();

        if (node.getNodeType() == Dom.XmlNodeType.ELEMENT) {
            List<Dom.XmlNode> elements = node.getChildElements();
            for (Integer i = elements.size() - 1; i >= 0; i--) {
                Dom.XmlNode child = elements.get(i);
                String property = child.getName();
                Object existing = structured.get(property);
                Object nodeToAdd = child.getText();
                if (child.getChildElements().size() > 0) {
                    Object newNode = parse(child);
                    nodeToAdd = collapseExistingNode(existing, newNode);
                } else {
                    nodeToAdd = collapseExistingNode(existing, nodeToAdd);
                }
                structured.put(property, nodeToAdd);

            }
        }
        return structured;
    }

    private static Object collapseExistingNode(Object existing, Object newNode) {
        Object node = newNode;
        if (existing != null) {
            if (existing instanceof List<Object>) {
                ((List<Object>) existing).add(newNode);
                node = existing;
            } else {
                List<Object> asList = new List<Object>();
                asList.add(newNode);
                asList.add(existing);
                node = asList;
            }
        }
        return node;
    }
}