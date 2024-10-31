@IsTest
public with sharing class QueryBuilderTest {

    @IsTest
    public static void givenPartsOfQueryThenBuildsExpectedString() {

        Set<String> fields = new Set<String>{
            'Id',
            'id',
            'NaMe',
            'name',
            '(select id from inner)'
        };
        String result = QueryBuilder.selectFields(fields).fromObject('Object').filter('this = foo and that = fu').orderBy('field1', true).orderBy('field2', false).build();
        System.assertEquals('SELECT Id,NaMe,(select id from inner) FROM Object WHERE this = foo and that = fu ORDER BY field1 ASC,field2 DESC', result);
        result = QueryBuilder.selectFields(fields).fromObject('Object').filter('this = foo and that = fu').orderBy(new List<String>{'field1', 'field2'}).build();
        System.assertEquals('SELECT Id,NaMe,(select id from inner) FROM Object WHERE this = foo and that = fu ORDER BY field1 ASC,field2 ASC', result);
        result = QueryBuilder.selectFields(fields).fromObject('Object').filter(FilterBuilder.newAnd().add('this = foo').add('that = fu')).orderBy(new List<String>{'field1', 'field2'}).build();
        System.assertEquals('SELECT Id,NaMe,(select id from inner) FROM Object WHERE (this = foo AND that = fu) ORDER BY field1 ASC,field2 ASC', result);
        result = QueryBuilder.selectFields(fields).fromObject('Object').filter(FilterBuilder.newAnd().add('this = foo').add('that = fu')).orderBy(new List<String>{'field1', 'field2'}).withLimit(100).build();
        System.assertEquals('SELECT Id,NaMe,(select id from inner) FROM Object WHERE (this = foo AND that = fu) ORDER BY field1 ASC,field2 ASC LIMIT 100', result);
        result = QueryBuilder.selectFields(fields).fromObject('Object').filter(FilterBuilder.newAnd().add('this = foo').add('that = fu')).orderBy('field1', true, true).orderBy('field2', true).withLimit(100).build();
        System.assertEquals('SELECT Id,NaMe,(select id from inner) FROM Object WHERE (this = foo AND that = fu) ORDER BY field1 ASC NULLS LAST,field2 ASC LIMIT 100', result);
        result = QueryBuilder.selectFields(fields).fromObject('Object').filter(FilterBuilder.newAnd().add('this = foo').add('that = fu')).orderBy('field1', true, false).orderBy('field2', true, true).withLimit(100).build();
        System.assertEquals('SELECT Id,NaMe,(select id from inner) FROM Object WHERE (this = foo AND that = fu) ORDER BY field1 ASC NULLS FIRST,field2 ASC NULLS LAST LIMIT 100', result);

    }

    @IsTest
    public static void buildsSimpleSelect() {
        System.assertEquals('SELECT Id FROM Account', QueryBuilder.selectFrom(Account.SObjectType).build());
    }

    @IsTest
    public static void givenConcretePartsOfQueryThenBuildsExpectedString() {

        Set<SObjectField> fields = new Set<SObjectField>{
            Account.fields.Name,
            Account.fields.CreatedDate
        };

        FilterBuilder filterBuilder = FilterBuilder.newAnd().add('this = foo').add('that = fu');
        String result = QueryBuilder.selectFields(fields)
            .fromObject(Account.SObjectType)
            .filter(filterBuilder)
            .orderBy('Name', true)
            .orderBy('field2', false)
            .build();
        System.assertEquals('SELECT Name,CreatedDate,Id FROM Account WHERE (this = foo AND that = fu) ORDER BY Name ASC,field2 DESC', result);
    }

    @IsTest
    public static void buildsQueryForSelectAll() {
        String result = QueryBuilder.selectAllFrom(Contact.SObjectType).build();
        System.assertNotEquals(null, result);
    }

    @IsTest
    public static void throwsQueryExceptionWhenMissingObjectDuringBuild() {


        Boolean error = false;
        try {
            QueryBuilder.selectFields(new Set<String>{
            }).build();
        } catch(QueryException e) {
            error = true;
            System.assertEquals('Missing object to query from.', e.getMessage());
        }
        System.assertEquals(true, error, 'Expected Query Exception but did not get one.');
    }
}