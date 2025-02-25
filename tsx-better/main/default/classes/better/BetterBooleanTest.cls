@IsTest
public with sharing class BetterBooleanTest {
    @IsTest
    public static void returnsExpectedTrueStateGivenParameter() {
        System.assertEquals(true, BetterBoolean.valueOf('1'));
        System.assertEquals(true, BetterBoolean.valueOf(1));
        System.assertEquals(true, BetterBoolean.valueOf('true'));
        System.assertEquals(true, BetterBoolean.valueOf('TRUE'));
        System.assertEquals(true, BetterBoolean.valueOf('TruE'));
        System.assertEquals(false, BetterBoolean.valueOf('f'));
        System.assertEquals(false, BetterBoolean.valueOf(''));
        System.assertEquals(false, BetterBoolean.valueOf(null));
        System.assertEquals(false, BetterBoolean.valueOf('0'));
        System.assertEquals(false, BetterBoolean.valueOf(0));
        System.assertEquals(false, BetterBoolean.valueOf('false'));
    }

    @IsTest
    public static void coalesceReturnsExpectedValue() {

        System.assertEquals(true, BetterBoolean.coalesce(true, true));
        System.assertEquals(false, BetterBoolean.coalesce(false, true));
        System.assertEquals(true, BetterBoolean.coalesce(null, true));
        System.assertEquals(false, BetterBoolean.coalesce(null, false));
    }
}