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

    @IsTest
    public static void expectedMaximumInteger() {
        System.assertEquals(2147483647, BetterInteger.MAX);
    }

    @IsTest
    public static void expectedMinimumInteger() {
        System.assertEquals(-2147483647, BetterInteger.MIN);
    }

    @IsTest
    public static void extractsFirstIntegerInString() {
        System.assertEquals(100, BetterInteger.parse('100 packs', true));
        System.assertEquals(300, BetterInteger.parse('Super 300 pack', true));
        System.assertEquals(0, BetterInteger.parse('None', true));
        System.assertEquals(null, BetterInteger.parse('None', false));
        System.assertEquals(1, BetterInteger.parse('Only 1', false));
        System.assertEquals(-1, BetterInteger.parse('Negative -1', false));
        System.assertEquals(-4, BetterInteger.parse('-4 value', false));
        System.assertEquals(4, BetterInteger.parse('four entries', false));
    }

    @IsTest
    public static void convertsTextToNumber() {

        System.assertEquals(1, BetterInteger.textToNumber('one'));
        System.assertEquals(-28, BetterInteger.textToNumber('negative twenty eight'));
        System.assertEquals(2, BetterInteger.textToNumber('two'));
        System.assertEquals(17, BetterInteger.textToNumber('seventeen'));
        System.assertEquals(0, BetterInteger.textToNumber('zero'));
        System.assertEquals(358, BetterInteger.textToNumber('three hundred fifty eight'));
        System.assertEquals(7217, BetterInteger.textToNumber('seven thousand two hundred and seventeen'));
        System.assertEquals(62, BetterInteger.textToNumber('invalid content sixty two'));
        System.assertEquals(null, BetterInteger.textToNumber(''));
    }
}