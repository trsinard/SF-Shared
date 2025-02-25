@IsTest
public with sharing class BetterSobjectTest {

    @IsTest
    public static void givenSobjectWithFieldsThenRemovesSpecifiedField() {

        Account account = new Account(
            Name = 'Test',
            AccountSource = 'Source',
            BillingStreet = ''
        );

        System.assertEquals('{"attributes":{"type":"Account"},"Name":"Test","AccountSource":"Source","BillingStreet":""}',JSON.serialize(account));

        Account result = (Account) BetterSobject.removeField(account, 'BillingStreet');
        System.assertEquals('{"attributes":{"type":"Account"},"AccountSource":"Source","Name":"Test"}',JSON.serialize(result));

        result = (Account) BetterSobject.removeField(result, 'AccountSource');
        System.assertEquals('{"attributes":{"type":"Account"},"Name":"Test"}',JSON.serialize(result));
    }

    @IsTest
    public static void safelyAppliesValueDynamically() {

        Account acct = new Account();
        acct = (Account) BetterSobject.applyField(acct, 'Name', 'Test');
        System.assertEquals('Test', acct.Name);
        acct = (Account) BetterSobject.applyField(acct, Account.fields.Name, 'Test2');
        System.assertEquals('Test2', acct.Name);
        Boolean error = false;
        try {
            BetterSobject.applyField(acct, 'NoExist', 'Test');
        } catch (Exception e) {
            error = true;
        }
        System.assertEquals(false, error);
    }

    @IsTest
    public static void safelyRetrievesValueDynamically() {

        Account acct = new Account(
            Name = 'Foo'
        );
        Object result = BetterSobject.getField(acct, 'Name');
        System.assertEquals('Foo', result);
        result = BetterSobject.getField(acct, Account.fields.Name);
        System.assertEquals('Foo', result);
        result = BetterSobject.getField(acct, 'NoExist');
        System.assertEquals(null, result);
    }
}