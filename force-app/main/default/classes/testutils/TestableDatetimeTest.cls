/**
 * @author Timothy Sinard
 *
 */
@IsTest
public class TestableDatetimeTest {

    @IsTest
    public static void givenDateThenReturnsStubbedDate() {

        Datetime stubbedNow = Datetime.newInstance(1991,09,12, 13,30,15);
        System.assertNotEquals(null, TestableDatetime.now());
        System.assertNotEquals(stubbedNow, TestableDatetime.now());
        TestableDatetime.setNow(stubbedNow);
        System.assertEquals(stubbedNow, TestableDatetime.now());
        System.assertEquals(stubbedNow.date(), TestableDatetime.today());
    }
}