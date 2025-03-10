/**
 * @author Timothy Sinard
 *
 */
@IsTest
public class JsonUtilTest {

    private static String exampleJson = '{"test_a": "a","test_c": ["c",{"fu":"fi"}],"test_b_nested": {"level_1": {"level_2": {"level_3": {"foo": "bar","num": 2}},"level_2_branch": {"bar": "foo"}}},"test_b_with_list": { "branch" : ["a","b","c",{"layer" :  3}], "branch_2" : ["x","y","z"],"object" : {"layer": 1},"value" : 2},"value_list": [1,2,3,"item","entry",6],"obj_list": [{"tn": "Tennessee","areas" : ["west", "middle", "east"]},{"ga": "Georgia"}]}';
    private static String exampleJsonArray = '[' + exampleJson + ',{"foo2" : "bar2"}]';

    @IsTest
    public static void parsesStringFromList() {
        System.assertEquals(null, JsonUtil.stringFromPath(exampleJson, 'obj_list[0].ga'));
        System.assertEquals('Tennessee', JsonUtil.stringFromPath(exampleJson, 'obj_list[0].tn'));
        System.assertEquals('Georgia', JsonUtil.valueFromPath(exampleJson, 'obj_list[1].ga'));
        System.assertEquals(null, JsonUtil.stringFromPath(exampleJson, 'obj_list[1].tn'));
    }

    @IsTest
    public static void parsesStringFromListViaApi() {
        System.assertEquals(JsonApi.stringFromPath(exampleJson, 'obj_list[0].ga'), JsonUtil.stringFromPath(exampleJson, 'obj_list[0].ga'));
        System.assertEquals(JsonApi.stringFromPath(exampleJson, 'obj_list[0].tn'), JsonUtil.stringFromPath(exampleJson, 'obj_list[0].tn'));
        System.assertEquals(JsonApi.valueFromPath(exampleJson, 'obj_list[1].ga'), JsonUtil.valueFromPath(exampleJson, 'obj_list[1].ga'));
        System.assertEquals(JsonApi.stringFromPath(exampleJson, 'obj_list[1].tn'), JsonUtil.stringFromPath(exampleJson, 'obj_list[1].tn'));
    }

    @IsTest
    public static void parsesObjectFromList() {
        Map<String, Object> expected0 = new Map<String, Object>{
            'tn' => 'Tennessee',
            'areas' => new List<String>{
                'west', 'middle', 'east'
            }
        };
        Map<String, Object> expected1 = new Map<String, Object>{
            'ga' => 'Georgia'
        };
        Map<String, Object> expected2 = null;
        System.assertEquals(expected0, JsonUtil.valueFromPath(exampleJson, 'obj_list[0]'));
        System.assertEquals(expected1, JsonUtil.valueFromPath(exampleJson, 'obj_list[1]'));
        System.assertEquals(expected2, JsonUtil.valueFromPath(exampleJson, 'obj_list[2]'));
    }

    @IsTest
    public static void parsesObjectFromListViaApi() {
        System.assertEquals(JsonApi.valueFromPath(exampleJson, 'obj_list[0]'), JsonUtil.valueFromPath(exampleJson, 'obj_list[0]'));
        System.assertEquals(JsonApi.valueFromPath(exampleJson, 'obj_list[1]'), JsonUtil.valueFromPath(exampleJson, 'obj_list[1]'));
        System.assertEquals(JsonApi.valueFromPath(exampleJson, 'obj_list[2]'), JsonUtil.valueFromPath(exampleJson, 'obj_list[2]'));
    }

    @IsTest
    public static void parsesValueFromDeepStructure() {

        System.assertEquals('bar', JsonUtil.valueFromPath(exampleJson, 'test_b_nested.level_1.level_2.level_3.foo'));
        System.assertEquals(2, JsonUtil.valueFromPath(exampleJson, 'test_b_nested.level_1.level_2.level_3.num'));
        System.assertEquals(2, JsonUtil.integerFromPath(exampleJson, 'test_b_nested.level_1.level_2.level_3.num'));
        System.assertEquals(new Map<String, Object>{
            'foo' => 'bar',
            'num' => 2
        }, JsonUtil.valueFromPath(exampleJson, 'test_b_nested.level_1.level_2.level_3'));
    }

    @IsTest
    public static void parsesValueFromDeepStructureViaApi() {

        System.assertEquals(JsonApi.valueFromPath(exampleJson, 'test_b_nested.level_1.level_2.level_3.foo'), JsonUtil.valueFromPath(exampleJson, 'test_b_nested.level_1.level_2.level_3.foo'));
        System.assertEquals(JsonApi.valueFromPath(exampleJson, 'test_b_nested.level_1.level_2.level_3.num'), JsonUtil.valueFromPath(exampleJson, 'test_b_nested.level_1.level_2.level_3.num'));
        System.assertEquals(JsonApi.integerFromPath(exampleJson, 'test_b_nested.level_1.level_2.level_3.num'), JsonUtil.integerFromPath(exampleJson, 'test_b_nested.level_1.level_2.level_3.num'));
        System.assertEquals(JsonApi.valueFromPath(exampleJson, 'test_b_nested.level_1.level_2.level_3'), JsonUtil.valueFromPath(exampleJson, 'test_b_nested.level_1.level_2.level_3'));
    }

    @IsTest
    public static void parsesValueFromList() {

        System.assertEquals(new List<Object>{
            1, 2, 3, 'item', 'entry', 6
        }, JsonUtil.valueFromPath(exampleJson, 'value_list'));
        System.assertEquals(1, JsonUtil.valueFromPath(exampleJson, 'value_list[0]'));
        System.assertEquals(2, JsonUtil.valueFromPath(exampleJson, 'value_list[1]'));
        System.assertEquals(3, JsonUtil.valueFromPath(exampleJson, 'value_list[2]'));
        System.assertEquals('item', JsonUtil.valueFromPath(exampleJson, 'value_list[3]'));
        System.assertEquals('entry', JsonUtil.valueFromPath(exampleJson, 'value_list[4]'));
        System.assertEquals(6, JsonUtil.valueFromPath(exampleJson, 'value_list[5]'));
        System.assertEquals(null, JsonUtil.valueFromPath(exampleJson, 'value_list[6]'));
    }

    @IsTest
    public static void parsesValueFromListViaApi() {

        System.assertEquals(JsonApi.valueFromPath(exampleJson, 'value_list'), JsonUtil.valueFromPath(exampleJson, 'value_list'));
        System.assertEquals(JsonApi.valueFromPath(exampleJson, 'value_list[0]'), JsonUtil.valueFromPath(exampleJson, 'value_list[0]'));
        System.assertEquals(JsonApi.valueFromPath(exampleJson, 'value_list[1]'), JsonUtil.valueFromPath(exampleJson, 'value_list[1]'));
        System.assertEquals(JsonApi.valueFromPath(exampleJson, 'value_list[2]'), JsonUtil.valueFromPath(exampleJson, 'value_list[2]'));
        System.assertEquals(JsonApi.valueFromPath(exampleJson, 'value_list[3]'), JsonUtil.valueFromPath(exampleJson, 'value_list[3]'));
        System.assertEquals(JsonApi.valueFromPath(exampleJson, 'value_list[4]'), JsonUtil.valueFromPath(exampleJson, 'value_list[4]'));
        System.assertEquals(JsonApi.valueFromPath(exampleJson, 'value_list[5]'), JsonUtil.valueFromPath(exampleJson, 'value_list[5]'));
        System.assertEquals(JsonApi.valueFromPath(exampleJson, 'value_list[6]'), JsonUtil.valueFromPath(exampleJson, 'value_list[6]'));
    }

    @IsTest
    public static void parsesValueWhenStructureIsAnArray() {

        System.assertEquals('Tennessee', JsonUtil.valueFromPath(exampleJsonArray, '[0].obj_list[0].tn'));
        System.assertEquals('Georgia', JsonUtil.valueFromPath(exampleJsonArray, '[0].obj_list[1].ga'));
        System.assertEquals(null, JsonUtil.valueFromPath(exampleJsonArray, '[1].obj_list[1].ga'));
        System.assertEquals('bar2', JsonUtil.valueFromPath(exampleJsonArray, '[1].foo2'));
    }

    @IsTest
    public static void parsesValueWhenStructureIsAnArrayViaApi() {

        System.assertEquals(JsonApi.valueFromPath(exampleJsonArray, '[0].obj_list[0].tn'),JsonUtil.valueFromPath(exampleJsonArray, '[0].obj_list[0].tn'));
        System.assertEquals(JsonApi.valueFromPath(exampleJsonArray, '[0].obj_list[1].ga'),JsonUtil.valueFromPath(exampleJsonArray, '[0].obj_list[1].ga'));
        System.assertEquals(JsonApi.valueFromPath(exampleJsonArray, '[1].obj_list[1].ga'),JsonUtil.valueFromPath(exampleJsonArray, '[1].obj_list[1].ga'));
        System.assertEquals(JsonApi.valueFromPath(exampleJsonArray, '[1].foo2'),JsonUtil.valueFromPath(exampleJsonArray, '[1].foo2'));
    }

    @IsTest
    public static void parsesValueWhenObjectContainsMixedStructures() {

        System.assertEquals(new List<Object>{
            'a', 'b', 'c', new Map<String, Object>{
                'layer' => 3
            }
        }, JsonUtil.valueFromPath(exampleJson, 'test_b_with_list.branch'));
        System.assertEquals(new List<String>{
            'x', 'y', 'z'
        }, JsonUtil.valueFromPath(exampleJson, 'test_b_with_list.branch_2'));
        System.assertEquals('a', JsonUtil.valueFromPath(exampleJson, 'test_b_with_list.branch[0]'));
        System.assertEquals(3, JsonUtil.valueFromPath(exampleJson, 'test_b_with_list.branch[3].layer'));
        System.assertEquals('y', JsonUtil.valueFromPath(exampleJson, 'test_b_with_list.branch_2[1]'));
        System.assertEquals(1, JsonUtil.valueFromPath(exampleJson, 'test_b_with_list.object.layer'));
        System.assertEquals(2, JsonUtil.valueFromPath(exampleJson, 'test_b_with_list.value'));
    }

    @IsTest
    public static void gracefullyHandlesInvalidJson() {

        Object results = JsonUtil.valueFromPath('bad', '1.1');
        System.assertEquals(null, results);
    }

    @IsTest
    public static void extractsValueGivenSearchedProperty() {

        String payload = '[{"key": 1,"value" : "test1"},{"key": 2,"value" : "test2"},{"key": 3,"value" : "test3"},{"key": 4,"value" : "test4"},{"key": 5,"value" : "test5"},{"key": 6,"value" : "test6"}]';
        Object results = JsonUtil.fromPathMatchingAttribute(payload, 'value', 'key', 3);
        System.assertEquals('test3', results);
        Object resultsNoMatch = JsonUtil.fromPathMatchingAttribute(payload, 'value', 'key', 30);
        System.assertEquals(null, resultsNoMatch);
    }

    @IsTest
    public static void extractsValueGivenSearchedPropertyViaApi() {

        String payload = '[{"key": 1,"value" : "test1"},{"key": 2,"value" : "test2"},{"key": 3,"value" : "test3"},{"key": 4,"value" : "test4"},{"key": 5,"value" : "test5"},{"key": 6,"value" : "test6"}]';
        Object results = JsonApi.findObjectOnPathWhereAttributeEqualsValue(payload, 'value', 'key', 3);
        System.assertEquals('test3', results);
        Object resultsNoMatch = JsonApi.findObjectOnPathWhereAttributeEqualsValue(payload, 'value', 'key', 30);
        System.assertEquals(null, resultsNoMatch);
    }

    @IsTest
    public static void extractsValueGivenSearchedPropertyInNestedStructure() {

        String payload = '{"nested": {"arbitrary": 0,"the_list": [{"key": 1,"value": "test1"},{"key": 2,"value": "test2"},{"key": 3,"value": "test3"},{"key": 4,"value": "test4"},{"key": 5,"value": "test5"},{"key": 6,"value": "test6"}]}}';
        Object results = JsonUtil.fromPathMatchingAttribute(payload, 'nested.the_list.value', 'key', 3);
        System.assertEquals('test3', results);
    }

}