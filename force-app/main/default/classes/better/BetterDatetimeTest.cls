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
    public static void givenAmbiguousDateConvertsToTypedDate() {
        Date expected = Date.newInstance(2021, 12, 30);
        System.assertEquals(expected, BetterDatetime.toDate('2021-12-30'), 'Failed to convert from String');
        System.assertEquals(expected, BetterDatetime.toDate(Datetime.newInstance(2021, 12, 30, 01, 30, 00)), 'Failed to convert from Datetime');
        System.assertEquals(expected, BetterDatetime.toDate('12/30/2021'), 'Failed to convert from Localized String');
        Object untypedDate = Date.newInstance(2021, 12, 30);
        System.assertEquals(expected, BetterDatetime.toDate(untypedDate), 'Failed to convert from untyped date');
    }

    @IsTest
    public static void givenInvalidDateThenToDateReturnsNull() {
        System.assertEquals(null, BetterDatetime.toDate('invalid'));
    }

    @IsTest
    public static void givenTwoDatesThenReturnsMax() {
        Date d1 = Date.newInstance(2021, 09, 12);
        Date d2 = Date.newInstance(2020, 10, 30);
        System.assertEquals(d1, BetterDatetime.max(d1, d2));
        System.assertEquals(d1, BetterDatetime.max(d2, d1));
        System.assertEquals(d1, BetterDatetime.max(null, d1));
        System.assertEquals(d2, BetterDatetime.max(d2, null));
        System.assertEquals(null, BetterDatetime.max(null, null));
    }

    @IsTest
    public static void givenTwoDatesThenReturnsMin() {
        Date d1 = Date.newInstance(2021, 09, 12);
        Date d2 = Date.newInstance(2020, 10, 30);
        System.assertEquals(d2, BetterDatetime.min(d1, d2));
        System.assertEquals(d2, BetterDatetime.min(d2, d1));
        System.assertEquals(d1, BetterDatetime.min(null, d1));
        System.assertEquals(d2, BetterDatetime.min(d2, null));
        System.assertEquals(null, BetterDatetime.min(null, null));
    }
}