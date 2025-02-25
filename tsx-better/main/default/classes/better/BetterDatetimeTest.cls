@IsTest
public with sharing class BetterDatetimeTest {

    @IsTest
    public static void returnsMinMaxBetweenDateTimes() {
        Datetime dt1 = Datetime.newInstance(2024, 08, 20, 11, 36, 35);
        Datetime dt2 = Datetime.newInstance(2024, 08, 20, 11, 36, 37);
        Datetime dt3 = Datetime.newInstance(2024, 08, 20, 11, 36, 37);

        System.assertEquals(dt2, BetterDatetime.max(dt1,dt2));
        System.assertEquals(dt1, BetterDatetime.min(dt1,dt2));
        System.assertEquals(dt2, BetterDatetime.min(dt3,dt2));
    }

    @IsTest
    public static void parsesDatetime() {

        System.assertEquals(Datetime.newInstance(2024, 08, 20, 11, 36, 35), BetterDatetime.valueOf('2024-08-20T11:36:35-04:00'));
        System.assertEquals(null, BetterDatetime.valueOf('0000'));
    }

    @IsTest
    public static void givenDatetimeChecksIfBetweenTwoBindingDatetimes() {

        Datetime toCheck = Datetime.newInstance(2022, 12, 20, 11, 0, 0);
        Datetime dtGreater = Datetime.newInstance(2022, 12, 20, 12, 0, 0);
        Datetime dtLesser = Datetime.newInstance(2022, 12, 20, 10, 0, 0);
        Datetime dtEqual = Datetime.newInstance(2022, 12, 20, 11, 0, 0);
        System.assertEquals(true, BetterDatetime.isBetween(toCheck, dtLesser, dtGreater), 'Datetime is between the lesser and greater.');
        System.assertEquals(false, BetterDatetime.isBetween(toCheck, dtLesser, dtLesser), 'Datetime is not between two lessers.');
        System.assertEquals(false, BetterDatetime.isBetween(toCheck, dtGreater, dtGreater), 'Datetime is not between two greaters.');
        System.assertEquals(false, BetterDatetime.isBetween(toCheck, dtLesser, dtEqual), 'Datetime is not between lesser and equal when using helper method.');
        System.assertEquals(true, BetterDatetime.isBetween(toCheck, dtLesser, true, dtEqual, true, true), 'Datetime is between lesser and equal when specified inclusive flag.');
        System.assertEquals(true, BetterDatetime.isBetween(toCheck, null, true, null, true, true), 'Datetime is between null when specified nullBoundless flag.');
        System.assertEquals(false, BetterDatetime.isBetween(toCheck, null, true, null, true, false), 'Datetime is not between null when specified false nullBoundless flag.');
    }

    @IsTest
    public static void givenDateTimesThenDeterminesDifferenceByIntervals() {

        Datetime dt1 = Datetime.newInstance(2023, 03, 12, 09, 15, 00);
        Datetime dt2 = Datetime.newInstance(2023, 03, 12, 09, 30, 00);
        Datetime dt3 = Datetime.newInstance(2023, 03, 12, 09, 30, 10);
        Datetime dt4 = Datetime.newInstance(2023, 03, 22, 09, 30, 10);

        System.assertEquals(10000, BetterDatetime.difference(dt2, dt3, BetterDatetime.Interval.MILLISECONDS));
        System.assertEquals(10000, BetterDatetime.difference(dt2, dt3, null));
        System.assertEquals(10, BetterDatetime.difference(dt2, dt3, BetterDatetime.Interval.SECONDS));
        System.assertEquals(15, BetterDatetime.difference(dt1, dt2, BetterDatetime.Interval.MINUTES));
        System.assertEquals(240.25, BetterDatetime.difference(dt1, dt4, BetterDatetime.Interval.HOURS));
        System.assertEquals(10, BetterDatetime.difference(dt3, dt4, BetterDatetime.Interval.DAYS));

    }

    @IsTest
    public static void formatsDateAsTimelessDatetimeString() {

        System.assertEquals('2000-05-02T00:00:00-04:00', BetterDatetime.format(Date.newInstance(2000,05,02)));
    }
}