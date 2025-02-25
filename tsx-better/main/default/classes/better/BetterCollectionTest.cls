@IsTest
public with sharing class BetterCollectionTest {

    @IsTest
    public static void givenCollectionWithOutOfBoundsIndexSafelyGetsNull() {


        System.assertEquals(null, BetterCollection.get(null, 1));
        System.assertEquals(null, BetterCollection.get(new List<String>(), 10));
        System.assertEquals(null, BetterCollection.get(new List<String>(), -1));
    }

    @IsTest
    public static void givenCollectionWithIndexSafelyGetsElement() {

        System.assertEquals('Foo', BetterCollection.get(new List<String>{'Bar','Foo','Fu'}, 1));
    }

    @IsTest
    public static void givenSObjectCollectionThenPlucksListOfKeyValues() {

        List<Account> accounts = new List<Account>{
            new Account (Name = 'Test 1', Description = 'Foo 1'),
            new Account (Name = 'Test 2', Description = 'Foo 2'),
            new Account (Name = 'Test 3', Description = 'Foo 3')
        };
        System.assertEquals(new List<Object>{'Test 1', 'Test 2', 'Test 3'}, BetterCollection.pluck(accounts, 'Name'));
    }

    @IsTest
    public static void givenNullCollectionThenReturnsEmptyCollection() {
        System.assertNotEquals(null, BetterCollection.noNull(null));
    }

    @IsTest
    public static void givenNonNullCollectionThenReturnsCollection() {
        List<String> collection = new List<String>();
        System.assertEquals(collection, BetterCollection.noNull(collection));
    }

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

        System.assertEquals(expected, BetterCollection.slice(toSlice, 2, 4));
    }

    @IsTest
    public static void givenObjectArrayWithIndicesThenReturnsSublist() {

        List<Object> toSlice = new List<Object>{
            'Entry A',
            2,
            'Entry C',
            4,
            'Entry E',
            'Entry F'
        };

        List<Object> expected = new List<Object>{
            'Entry C',
            4
        };

        System.assertEquals(expected, BetterCollection.slice(toSlice, 2, 4));
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
        }, BetterCollection.slice(toSlice, -2, 4));
        System.assertEquals(new List<String>{
            'Entry C', 'Entry D', 'Entry E', 'Entry F'
        }, BetterCollection.slice(toSlice, 2, 400));
        System.assertEquals(new List<String>{
        }, BetterCollection.slice(toSlice, 4, 2));

    }

    @IsTest
    public static void safelyGetsValueAtIndex() {

        List<Object> foo = new List<Object>{
            'a', 2
        };
        List<Object> bar = null;
        System.assertEquals(null, BetterCollection.at(bar, null));
        System.assertEquals(null, BetterCollection.at(bar, -1));
        System.assertEquals(null, BetterCollection.at(bar, 1));
        System.assertEquals(null, BetterCollection.at(foo, null));
        System.assertEquals(null, BetterCollection.at(foo, -1));
        System.assertEquals(null, BetterCollection.at(foo, 1000));
        System.assertEquals('a', BetterCollection.at(foo, 0));
        System.assertEquals(2, BetterCollection.at(foo, 1));
    }

    @IsTest
    public static void detectsWhenCollectionIsEmpty() {

        System.assertEquals(false, BetterCollection.isEmpty(new List<Object>{1, 'Foo'}));
        System.assertEquals(false, BetterCollection.isEmpty(new List<String>{'Foo'}));
        System.assertEquals(true, BetterCollection.isEmpty(new List<String>{}));
        System.assertEquals(true, BetterCollection.isEmpty(new List<Integer>()));
        System.assertEquals(true, BetterCollection.isEmpty(null));
        System.assertEquals(true, BetterCollection.isEmpty(1));
    }

    @IsTest
    public static void removesDuplicatesWhenVaryingCase() {

        Set<String> baseline = new Set<String>{'Id','id','Foo'};
        System.assertEquals(3, baseline.size());
        System.assertEquals(2, BetterCollection.dedupeIgnoreCase(baseline).size());
    }

    @IsTest
    public static void plucksValuesAsId() {

        List<Account> accounts = new List<Account>{
            new Account(Id = '0012300000hQHnwAAG'),
            new Account(Id = '0012300000hQHnwAAH'),
            new Account(Id = '0012300000hQHnwAAI')
        };
        List<Id> results = BetterCollection.pluckId(accounts, 'Id');
        System.assertEquals('0012300000hQHnwAAG', results[0]);
        System.assertEquals('0012300000hQHnwAAH', results[1]);
        System.assertEquals('0012300000hQHnwAAI', results[2]);
        System.assertEquals(3, results.size());
    }
}