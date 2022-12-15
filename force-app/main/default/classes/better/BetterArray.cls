/**
 * @author Timothy Sinard
 *
 */
public class BetterArray {

    public static List<String> slice(List<String> objs, Integer startIndex, Integer endIndex) {
        startIndex = Math.max(0, startIndex);
        endIndex = Math.min(objs.size(), endIndex);
        List<String> newObjs = new List<String>();
        for (Integer i = startIndex; i < endIndex && i < objs.size(); i++) {
            newObjs.add(objs[i]);
        }
        return newObjs;
    }

    public static Object at(List<Object> lst, Integer index) {
        return lst != null && index < lst.size() && index >= 0 ? lst.get(index) : null;
    }

    public static Boolean isEmpty(Object collection) {
        Boolean results = collection == null;
        if(!results) {
            try {
                String serialized = JSON.serialize(collection);
                List<Object> deserialized = (List<Object>) JSON.deserializeUntyped(serialized);
                results = deserialized == null || deserialized.isEmpty();
            } catch(System.TypeException e) {
                results = true;
            }
        }
        return results;
    }

}