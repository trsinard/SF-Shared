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

    public static Date toDate(Object obj) {
        Date result = null;
        if(obj != null) {
            try {
                result = Date.valueOf(obj instanceof String ? (String) obj : BetterString.valueOf(obj));
            } catch( System.TypeException ste) {
                if(obj instanceof String) {
                    try {
                        result = Date.parse((String) obj);
                    } catch(System.TypeException ste1) {
                        result = null;
                    }
                }
            }
        }
        return result;
    }

    public static Date max(Date d1, Date d2) {
        return (d1 != null && d2 == null) || d1 > d2 ? d1 : d2;
    }

    public static Date min(Date d1, Date d2) {
        return (d1 != null && d2 == null) || d1 < d2 ? d1 : d2;
    }
}