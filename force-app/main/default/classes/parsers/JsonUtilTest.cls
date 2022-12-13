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
    public static void parsesValueWhenStructureIsAnArray() {

        System.assertEquals('Tennessee', JsonUtil.valueFromPath(exampleJsonArray, '[0].obj_list[0].tn'));
        System.assertEquals('Georgia', JsonUtil.valueFromPath(exampleJsonArray, '[0].obj_list[1].ga'));
        System.assertEquals(null, JsonUtil.valueFromPath(exampleJsonArray, '[1].obj_list[1].ga'));
        System.assertEquals('bar2', JsonUtil.valueFromPath(exampleJsonArray, '[1].foo2'));
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

        Object results = JsonUtil.valueFromPath('bad','1.1');
        System.assertEquals(null, results);
    }

}