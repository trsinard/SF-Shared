/**
 * @author Timothy Sinard
 *
 */
public class JsonNode {

    private Integer index;
    private String property;
    private String path;
    private Boolean forArray;
    private JsonNode nextNode;
    private Object value;

    public JsonNode lastNode() {
        JsonNode node = this;
        while (node.hasNext()) {
            node = node.next();
        }
        return node;
    }

    public JsonNode(String path, Object untyped) {
        this.path = path;
        this.forArray = false;
        this.value = null;
        this.nextNode = null;

        if (String.isNotBlank(path)) {
            this.property = path.substringBefore('.');
            String nextPath = path.substringAfter('.');
            Matcher arrayBracketsMatcher = Pattern.compile('\\[([0-9]*?)\\]').matcher(property);
            if (arrayBracketsMatcher.find()) {
                this.forArray = true;
                this.property = this.property.substringBefore('[');
                this.index = Integer.valueOf(arrayBracketsMatcher.group(1));
            }
            Object obj = (untyped instanceof Map<String, Object>) ? ((Map<String, Object>) untyped).get(property) : untyped;
            this.value = obj;
            if(this.forArray) {
                this.value = BetterArray.at((List<Object>)obj,index);
                obj = this.value;
            }
            if (!String.isBlank(nextPath)) {
                if (obj instanceof Map<String, Object>) {
                    this.nextNode = new JsonNode(nextPath, obj);
                }
            }
        }
    }

    public Object getValue() {
        return this.value;
    }
    public String getProperty() {
        return this.property;
    }

    public Integer getIndex() {
        return this.index;
    }

    public Boolean forArray() {
        return this.forArray;
    }

    public Boolean hasNext() {
        return this.nextNode != null;
    }

    public JsonNode next() {
        return this.nextNode;
    }

}