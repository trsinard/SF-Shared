/**
 * @author Timothy Sinard
 *
 */
public class BetterDatetime {

    public static Datetime valueOf(Object obj) {
        Datetime result = null;
        if(obj != null) {
            try {
                result = Datetime.valueOf(obj instanceof String ? (String) obj : BetterString.valueOf(obj));
            } catch(System.TypeException ste) {
                if(obj instanceof String) {
                    try {
                        result = Datetime.parse((String) obj);
                    } catch(System.TypeException ste1) {
                        result = null;
                    }
                }
            }
        }
        return result;
    }

    public static Datetime max(Datetime d1, Datetime d2) {
        return (d1 != null && d2 == null) || d1 > d2 ? d1 : d2;
    }

    public static Datetime min(Datetime d1, Datetime d2) {
        return (d1 != null && d2 == null) || d1 < d2 ? d1 : d2;
    }

}