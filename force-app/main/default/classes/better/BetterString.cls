/**
 * @author Timothy Sinard
 *
 */
public class BetterString {

    public static String valueOf(Object obj) {
        return valueOf(obj, false);
    }

    public static String valueOf(Object obj, Boolean emptyNull) {
        return obj == null && emptyNull ? '' : (obj == null ? null : String.valueOf(obj));
    }
}