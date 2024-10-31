@IsTest
public with sharing class SObjectIteratorTest {

    @IsTest
    public static void iteratesThroughAllElements() {

        List<Account> accounts = new List<Account>{
            new Account(Name = 'A'),
            new Account(Name = 'B'),
            new Account(Name = 'C'),
            new Account(Name = 'D')
        };

        SObjectIterator iterator = new SObjectIterator(accounts);
        List<Account> entries = new List<Account>();
        while(iterator.hasNext()) {
            entries.add((Account)iterator.next());
        }
        System.assertEquals(4,entries.size());
        System.assertEquals('A', entries[0].Name);
        System.assertEquals('B', entries[1].Name);
        System.assertEquals('C', entries[2].Name);
        System.assertEquals('D', entries[3].Name);
    }

    @IsTest
    public static void canPeekWithoutIterating() {


        List<Account> accounts = new List<Account>{
            new Account(Name = 'A'),
            new Account(Name = 'B'),
            new Account(Name = 'C'),
            new Account(Name = 'D')
        };
        SObjectIterator iterator = new SObjectIterator(accounts);
        Account firstElement = (Account) iterator.next();
        System.assertEquals('A', firstElement.Name);
        Account secondElement = (Account) iterator.peek();
        System.assertEquals('B', secondElement.Name);
        secondElement = (Account) iterator.next();
        System.assertEquals('B', secondElement.Name);
    }
}