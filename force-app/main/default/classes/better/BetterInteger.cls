/**
 * @author Timothy Sinard
 *
 */
public class BetterInteger {

    public static Integer valueOf(Object obj) {
        return valueOf(obj, false);
    }

    public static Integer valueOf(Object obj, Boolean zeroNull) {
        Integer result = zeroNull ? 0 : null;
        if (obj != null) {
            String str = String.valueOf(obj);
            try {
                if (str.containsIgnoreCase('E')) {
                    str = Decimal.valueOf(str).toPlainString();
                }
                str = str
                    .replaceAll(',', '')
                    .replaceAll(' ', '')
                    .split('\\.')[0];

                result = Integer.valueOf(str);
            } catch (System.TypeException te) {
            }
        }
        return result;
    }
}