/**
 * @author Timothy Sinard
 *
 */
@IsTest
public class BetterStringTest {

    @IsTest
    public static void safelyReturnsNullWhenParameterIsNull() {
        System.assertEquals(null, BetterString.valueOf(null));
    }

    @IsTest
    public static void returnsEmptyStringWhenNull() {
        System.assertEquals('', BetterString.valueOf(null, true));
    }

    @IsTest
    public static void returnsAsString() {
        Decimal foo = 485.3494;
        System.assertEquals('485.3494', BetterString.valueOf(foo, true));
    }
}