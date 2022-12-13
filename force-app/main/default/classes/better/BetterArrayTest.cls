/**
 * @author Timothy Sinard
 *
 */
@IsTest
public class BetterArrayTest {

    @IsTest
    public static void givenStringArrayWithIndicesThenReturnsSublist() {

        List<String> toSlice = new List<String>{
            'Entry A',
            'Entry B',
            'Entry C',
            'Entry D',
            'Entry E',
            'Entry F'
        };

        List<String> expected = new List<String>{
            'Entry C',
            'Entry D'
        };

        System.assertEquals(expected, BetterArray.slice(toSlice, 2, 4));
    }

    @IsTest
    public static void handlesInvalidParameters() {

        List<String> toSlice = new List<String>{
            'Entry A',
            'Entry B',
            'Entry C',
            'Entry D',
            'Entry E',
            'Entry F'
        };

        System.assertEquals(new List<String>{
            'Entry A', 'Entry B', 'Entry C', 'Entry D'
        }, BetterArray.slice(toSlice, -2, 4));
        System.assertEquals(new List<String>{
            'Entry C', 'Entry D', 'Entry E', 'Entry F'
        }, BetterArray.slice(toSlice, 2, 400));
        System.assertEquals(new List<String>{
        }, BetterArray.slice(toSlice, 4, 2));

    }

    @IsTest
    public static void safelyGetsValueAtIndex() {

        List<Object> foo = new List<Object>{
            'a', 2
        };
        List<Object> bar = null;
        System.assertEquals(null, BetterArray.at(bar, null));
        System.assertEquals(null, BetterArray.at(bar, -1));
        System.assertEquals(null, BetterArray.at(bar, 1));
        System.assertEquals(null, BetterArray.at(foo, null));
        System.assertEquals(null, BetterArray.at(foo, -1));
        System.assertEquals(null, BetterArray.at(foo, 1000));
        System.assertEquals('a', BetterArray.at(foo, 0));
        System.assertEquals(2, BetterArray.at(foo, 1));
    }
}