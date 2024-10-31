@IsTest
public with sharing class FilterBuilderTest {

    @IsTest
    public static void buildsOrCondition() {
        String nullVal = null;
        String withoutWhere = FilterBuilder.newOr()
            .add('(Field_2__c <= :field2 AND (Field_1__c >= :field1 OR Field_1__c = NULL))')
            .add('(Field_2__c <= :field1 AND (Field_1__c >= :field1 OR Field_1__c = NULL))')
            .add('(Field_2__c <= :field2 AND Field_1__c >= :field2) ')
            .add(nullVal)
            .add('       ')
            .build();
        System.assertEquals('((Field_2__c <= :field2 AND (Field_1__c >= :field1 OR Field_1__c = NULL)) OR (Field_2__c <= :field1 AND (Field_1__c >= :field1 OR Field_1__c = NULL)) OR (Field_2__c <= :field2 AND Field_1__c >= :field2))', withoutWhere);

        String withWhere = FilterBuilder.newOr()
            .add('(Field_2__c <= :field2 AND (Field_1__c >= :field1 OR Field_1__c = NULL))')
            .add('(Field_2__c <= :field1 AND (Field_1__c >= :field1 OR Field_1__c = NULL))')
            .add('(Field_2__c <= :field2 AND Field_1__c >= :field2) ')
            .add(nullVal)
            .add('       ')
            .build(true);
        System.assertEquals('WHERE ((Field_2__c <= :field2 AND (Field_1__c >= :field1 OR Field_1__c = NULL)) OR (Field_2__c <= :field1 AND (Field_1__c >= :field1 OR Field_1__c = NULL)) OR (Field_2__c <= :field2 AND Field_1__c >= :field2))', withWhere);
    }

    @IsTest
    public static void buildsAndCondition() {

        String nullVal = null;
        String withoutWhere = FilterBuilder.newAnd()
            .add('Field = 1')
            .add('Field2 = 2')
            .add(nullVal)
            .add('  ')
            .add('')
            .build();
        System.assertEquals('(Field = 1 AND Field2 = 2)', withoutWhere);

        String withoutWhereOverload = FilterBuilder.newAnd()
            .add('Field = 1')
            .add('Field2 = 2')
            .add(nullVal)
            .add('  ')
            .add('')
            .build(false);
        System.assertEquals('(Field = 1 AND Field2 = 2)', withoutWhereOverload);


        String withWhere = FilterBuilder.newAnd()
            .add('Field = 1')
            .add('Field2 = 2')
            .add(nullVal)
            .add('  ')
            .add('')
            .build(true);
        System.assertEquals('WHERE (Field = 1 AND Field2 = 2)', withWhere);
    }

    @IsTest
    public static void buildsGivenNestedFilterBuilder() {
        String filter = FilterBuilder.newAnd()
            .add('Field = 1')
            .add(FilterBuilder.newOr().add('A = 2').add('B = 3'))
            .build();
        System.assertEquals('(Field = 1 AND (A = 2 OR B = 3))', filter);
    }

}