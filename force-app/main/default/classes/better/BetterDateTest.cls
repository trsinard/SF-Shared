@IsTest
public with sharing class BetterDateTest {


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
    public static void getsDateOfWeekNameGivenDate() {
        System.assertEquals('Monday', BetterDate.dayOfWeekName(Date.newInstance(2022, 09, 12)));
        System.assertEquals('Thursday', BetterDate.dayOfWeekName(Date.newInstance(1991, 09, 12)));
    }

    @IsTest
    public static void getStartOfWeekGivenDate() {

        Date expected = Date.newInstance(2022, 09, 12);
        System.assertEquals(expected, BetterDate.getStartOfWeek(Date.newInstance(2022, 09, 15)));
    }

    @IsTest
    public static void parsesDateFromObject() {
        System.assertEquals(Date.newInstance(2021, 04, 26), BetterDate.valueOf('2021-04-26'));
        System.assertEquals(Date.newInstance(2021, 04, 26), BetterDate.valueOf('2021-04-26T01:30:00'));
        System.assertEquals(Date.newInstance(2021, 04, 26), BetterDate.valueOf('04/26/2021'));
        System.assertEquals(null, BetterDate.valueOf(null));
        System.assertEquals(null, BetterDate.valueOf(''));
        System.assertEquals(null, BetterDate.valueOf('invalid'));
    }

}