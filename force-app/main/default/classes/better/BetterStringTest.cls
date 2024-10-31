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

    @IsTest
    public static void generatesRandomString() {

        String result = BetterString.random(8);
        System.assertEquals(8, result.length());
        String result2 = BetterString.random(8);
        System.assertNotEquals(result, result2);

    }

    @IsTest
    public static void coalesceReturnsExpectedValue() {

        System.assertEquals('Initial', BetterString.coalesce('Initial', 'Fallback'));
        System.assertEquals('Fallback', BetterString.coalesce(null, 'Fallback'));
    }

    @IsTest
    public static void parseNumericCharactersTest(){

        System.assertEquals('11229', BetterString.parseNumericCharacters('11229', 5));
        System.assertEquals('', BetterString.parseNumericCharacters('', 5));
        System.assertEquals('', BetterString.parseNumericCharacters(null, 5));
        System.assertEquals('11235', BetterString.parseNumericCharacters('11235-123123123123', 5));
    }
}