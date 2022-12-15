/**
 * @author Timothy Sinard
 *
 */
@IsTest
public class BetterDatetimeTest {

    @IsTest
    public static void givenNullValueSafelyReturnsNull() {
        System.assertEquals(null, BetterDatetime.valueOf(null));
    }

    @IsTest
    public static void givenInvalidValueSafelyReturnsNull() {
        System.assertEquals(null, BetterDatetime.valueOf('invalid'));
    }

    @IsTest
    public static void givenValidValueReturnsExpectedDate() {
        Datetime expected = Datetime.newInstance(2021, 12, 30, 01, 30, 00);
        System.assertEquals(expected, BetterDatetime.valueOf('2021-12-30 01:30:00'), 'Failed to parse from String');
        System.assertEquals(expected, BetterDatetime.valueOf('12/30/2021, 1:30 AM'), 'Failed to parse from Localized String');
    }

    @IsTest
    public static void givenTwoDatesThenReturnsMax() {
        Datetime d1 = Datetime.newInstance(2020, 10, 30, 11,0,0);
        Datetime d2 = Datetime.newInstance(2020, 10, 30, 3, 0, 0);
        System.assertEquals(d1, BetterDatetime.max(d1, d2));
        System.assertEquals(d1, BetterDatetime.max(d2, d1));
        System.assertEquals(d1, BetterDatetime.max(null, d1));
        System.assertEquals(d2, BetterDatetime.max(d2, null));
        System.assertEquals(null, BetterDatetime.max(null, null));
    }

    @IsTest
    public static void givenTwoDatesThenReturnsMin() {
        Datetime d1 = Datetime.newInstance(2020, 10, 30, 11,0,0);
        Datetime d2 = Datetime.newInstance(2020, 10, 30, 3, 0, 0);
        System.assertEquals(d2, BetterDatetime.min(d1, d2));
        System.assertEquals(d2, BetterDatetime.min(d2, d1));
        System.assertEquals(d1, BetterDatetime.min(null, d1));
        System.assertEquals(d2, BetterDatetime.min(d2, null));
        System.assertEquals(null, BetterDatetime.min(null, null));
    }
}