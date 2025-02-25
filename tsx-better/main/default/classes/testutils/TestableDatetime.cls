/**
 * @author Timothy Sinard
 *
 */
public class TestableDatetime {

    private static Datetime now;

    public static Datetime now() {
        return TestableDatetime.now == null ? Datetime.now() : TestableDatetime.now;
    }

    public static Datetime setNow(Datetime stubbedNow) {
        TestableDatetime.now = stubbedNow;
        return TestableDatetime.now;
    }

    public static Date today() {
        return now == null ? Date.today() : TestableDatetime.now.date();
    }
}