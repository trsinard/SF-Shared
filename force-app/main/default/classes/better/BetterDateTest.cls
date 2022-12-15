/**
 * @author Timothy Sinard
 *
 */
@IsTest
public class BetterDateTest {


    @IsTest
    public static void givenAmbiguousDateConvertsToTypedDate() {
        Date expected = Date.newInstance(2021, 12, 30);
        System.assertEquals(expected, BetterDate.toDate('2021-12-30'), 'Failed to convert from String');
        System.assertEquals(expected, BetterDate.toDate(Datetime.newInstance(2021, 12, 30, 01, 30, 00)), 'Failed to convert from Datetime');
        System.assertEquals(expected, BetterDate.toDate('12/30/2021'), 'Failed to convert from Localized String');
        Object untypedDate = Date.newInstance(2021, 12, 30);
        System.assertEquals(expected, BetterDate.toDate(untypedDate), 'Failed to convert from untyped date');
    }

    @IsTest
    public static void givenInvalidDateThenToDateReturnsNull() {
        System.assertEquals(null, BetterDate.toDate('invalid'));
    }

    @IsTest
    public static void givenTwoDatesThenReturnsMax() {
        Date d1 = Date.newInstance(2021, 09, 12);
        Date d2 = Date.newInstance(2020, 10, 30);
        System.assertEquals(d1, BetterDate.max(d1, d2));
        System.assertEquals(d1, BetterDate.max(d2, d1));
        System.assertEquals(d1, BetterDate.max(null, d1));
        System.assertEquals(d2, BetterDate.max(d2, null));
        System.assertEquals(null, BetterDate.max(null, null));
    }

    @IsTest
    public static void givenTwoDatesThenReturnsMin() {
        Date d1 = Date.newInstance(2021, 09, 12);
        Date d2 = Date.newInstance(2020, 10, 30);
        System.assertEquals(d2, BetterDate.min(d1, d2));
        System.assertEquals(d2, BetterDate.min(d2, d1));
        System.assertEquals(d1, BetterDate.min(null, d1));
        System.assertEquals(d2, BetterDate.min(d2, null));
        System.assertEquals(null, BetterDate.min(null, null));
    }

    @IsTest
    public static void getsExpectedDayOfWeek() {

        System.assertEquals(4, BetterDate.dayOfWeek(Date.newInstance(1991, 09,12)));
    }
}