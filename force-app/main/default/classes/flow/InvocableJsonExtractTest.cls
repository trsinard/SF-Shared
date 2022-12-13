/**
 * @author Timothy Sinard
 *
 */

@IsTest
public class InvocableJsonExtractTest {

    @IsTest
    public static void givenPathsThenExtractsStringValue() {
        String json = '{"test_a": "a","test_c": ["c",{"fu":"fi"}],"test_b_nested": {"level_1": {"level_2": {"level_3": {"foo": "bar","num": 2}},"level_2_branch": {"bar": "foo"}}},"test_b_with_list": { "branch" : ["a","b","c",{"layer" :  3}], "branch_2" : ["x","y","z"],"object" : {"layer": 1},"value" : 2},"value_list": [1,2,3,"item","entry",6],"obj_list": [{"tn": "Tennessee","areas" : ["west", "middle", "east"]},{"ga": "Georgia"}]}';

        InvocableJsonExtract.Request req1 = new InvocableJsonExtract.Request();
        req1.json = json;
        req1.propertyPath = 'test_b_nested.level_1.level_2.level_3.foo';//bar;

        InvocableJsonExtract.Request req2 = new InvocableJsonExtract.Request();
        req2.json = json;
        req2.propertyPath = 'test_b_nested.level_1.level_2.level_3.num';//2;

        InvocableJsonExtract.Request req3 = new InvocableJsonExtract.Request();
        req3.json = json;
        req3.propertyPath = 'missing.path.is.safe';//null

        List<InvocableJsonExtract.Result> results = InvocableJsonExtract.extractJsonValue(new List<InvocableJsonExtract.Request>{
            req1,
            req2,
            req3
        });

        System.assertEquals(3, results.size(), 'Response size should be the same as request.');
        System.assertEquals('bar', results[0].value);
        System.assertEquals('2', results[1].value);
        System.assertEquals(null, results[2].value);
    }
}