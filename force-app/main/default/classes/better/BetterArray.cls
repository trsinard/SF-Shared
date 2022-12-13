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

}