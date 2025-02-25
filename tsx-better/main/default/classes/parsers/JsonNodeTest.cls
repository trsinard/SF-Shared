/**
 * @author Timothy Sinard
 *
 */
@IsTest
public class JsonNodeTest {

    @IsTest
    public static void givenUntypedStructureThenGeneratesNodeChain() {

        JsonNode node = new JsonNode('[0].foo.bar.test.entry', JsonUtil.deserialize('[{"foo":{"bar":{"test":{"entry":"example"}}}}]'));
        JsonNode lastNode = node.lastNode();
        System.assertEquals(true, node.hasNext());
        System.assertNotEquals(lastNode, node.next());
        System.assertEquals('example', lastNode.getValue());
        System.assertEquals('entry', lastNode.getProperty());
        System.assertEquals(null, lastNode.getIndex());
        System.assertEquals(false, lastNode.forArray());
        System.assertEquals(0, node.getIndex());
        System.assertEquals(true, node.forArray());
    }
}