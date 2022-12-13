/**
 * @author Timothy Sinard
 *
 */
public class JsonUtil {


    /*
        Given a JSON structure, this can be used to parse deep values from the structure recursively without having
        a concrete objects or knowing the complete structure. The path is a dot-notation, where square brackets
        can be used to access array entries.
        For example:
        level_1.level_2.my_array[2]
        level_1.level_2.my_array[2].key
        [0].object_in_array.key

     */
    public static Object valueFromPath(String payload, String path) {
        Object result = null;
        try {
            result =  fromPath(payload, path)?.lastNode()?.getValue();
        } catch(JSONException e) {
            System.debug(e.getMessage());
        }
        return result;
    }

    public static JsonNode fromPath(String payload, String path) {
        JsonNode node = new JsonNode(path, deserialize(payload));
        return node;
    }

    public static String stringFromPath(String payload, String path) {
        return BetterString.valueOf(valueFromPath(payload, path));
    }

    public static Integer integerFromPath(String payload, String path) {
        return BetterInteger.valueOf(valueFromPath(payload, path));
    }

    public static Object deserialize(String payload) {
        Object deserialized;
        if (payload != null) {
            payload = payload.trim();
            if (payload.startsWith('[')) {
                deserialized = convertObjectListToUntypedMapList((List<Object>) JSON.deserializeUntyped(payload));
            } else if (!payload.startsWith('{')) {
                deserialized = JSON.deserializeUntyped(payload);
            } else {
                deserialized = deserializeNestedStructure(payload);
            }
        }
        return deserialized;
    }

    private static Map<String, Object> deserializeNestedStructure(String payload) {
        Map<String, Object> deserialized = (Map<String, Object>) JSON.deserializeUntyped(payload);
        for (String key : deserialized.keySet()) {
            Object obj = deserialized.get(key);
            if (obj instanceof Map<String, Object>) {
                deserialized.put(key, deserialize(JSON.serialize(obj)));
            } else if (obj instanceof List<Object>) {
                deserialized.put(key, convertObjectListToUntypedMapList((List<Object>) obj));
            }
        }
        return deserialized;
    }

    private static List<Object> convertObjectListToUntypedMapList(List<Object> objList) {
        List<Object> untypedMapList = new List<Object>();
        for (Object entry : objList) {
            untypedMapList.add(deserialize(JSON.serialize(entry)));
        }
        return untypedMapList;
    }

}