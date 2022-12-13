/**
 * @author Timothy Sinard
 *
 */
@IsTest
public class BetterIntegerTest {

    @IsTest
    public static void returnsNullWhenInvalid() {
        System.assertEquals(null, BetterInteger.valueOf('ABC'));
    }

    @IsTest
    public static void returnsZeroWhenInvalid() {
        System.assertEquals(0, BetterInteger.valueOf('ABC', true));
    }

    @IsTest
    public static void returnsNumberWhenValid() {
        System.assertEquals(10, BetterInteger.valueOf('   10   '));
    }

    @IsTest
    public static void returnsIntegerFromDecimalWithCommas() {
        System.assertEquals(2495, BetterInteger.valueOf('2,495.48'));
    }

    @IsTest
    public static void returnsIntegerFromNegatives() {
        System.assertEquals(-2495, BetterInteger.valueOf('-2,495.48'));
    }

    @IsTest
    public static void handlesScientificNotationForDecimals() {
        System.assertEquals(138,BetterInteger.valueOf('1.384E+2'));
    }
}