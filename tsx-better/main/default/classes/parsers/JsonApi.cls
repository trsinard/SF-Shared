
global without sharing class JsonApi {
    /*
        Given a JSON structure, this can be used to parse deep values from the structure recursively without having
        a concrete objects or knowing the complete structure. The path is a dot-notation, where square brackets
        can be used to access array entries.
        For example:
        level_1.level_2.my_array[2]
        level_1.level_2.my_array[2].key
        [0].object_in_array.key

     */
    global static Object valueFromPath(String payload, String path) {
        return JsonUtil.valueFromPath(payload, path);
    }

    global static String stringFromPath(String payload, String path) {
        return JsonUtil.stringFromPath(payload, path);
    }

    global static Integer integerFromPath(String payload, String path) {
        return JsonUtil.integerFromPath(payload, path);
    }

    global static Object findObjectOnPathWhereAttributeEqualsValue(String payload, String path, String key, Object value) {
        return JsonUtil.fromPathMatchingAttribute(payload, path, key, value);
    }

}