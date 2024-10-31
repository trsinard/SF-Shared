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

    public static String random(Integer length) {
        String result = '';
        while (result.length() < length) {
            result += EncodingUtil.convertToHex(Crypto.generateAesKey(128));
        }
        return result.substring(0, length);
    }

    public static String coalesce(String initial, String fallback) {
        return String.isEmpty(initial) ? fallback : initial;
    }

    public static String parseNumericCharacters(String str, Integer length) {

        str = BetterString.valueOf(str, true).replaceAll('\\D+','');
        return str.substring(0, Math.min(str.length(), length));
    }
}