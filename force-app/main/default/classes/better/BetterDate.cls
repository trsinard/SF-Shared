/**
 * @author Timothy Sinard
 *
 */
public class BetterDate {

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

    public static Integer dayOfWeek(Date d1) {
        return Math.mod(Date.newInstance(1900, 1, 7).daysBetween(d1), 7);
    }
}