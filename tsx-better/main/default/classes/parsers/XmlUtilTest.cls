/**
 * @author Timothy Sinard
 *
 */
@IsTest
public class XmlUtilTest {


    @IsTest
    public static void recursivelyParsesXmlToJsonWithNestedElements() {

        String xml = '<AddressValidateResponse><Address ID="0"><Address1>STE K</Address1><Address2>29851 AVENTURA</Address2><City>RANCHO SANTA MARGARITA</City><CityAbbreviation>RCHO STA MARG</CityAbbreviation><State>CA</State><Zip5>92688</Zip5><Zip4>2014</Zip4><DeliveryPoint>83</DeliveryPoint><CarrierRoute>C057</CarrierRoute><Footnotes>N</Footnotes><DPVConfirmation>Y</DPVConfirmation><DPVCMRA>N</DPVCMRA><DPVFootnotes>AABB</DPVFootnotes><Business>Y</Business><CentralDeliveryPoint>N</CentralDeliveryPoint><Vacant>N</Vacant></Address></AddressValidateResponse>';
        String json = XmlUtil.convertXmlToJson(xml);
        String expected = '{"Address":{"Address1":"STE K","Address2":"29851 AVENTURA","City":"RANCHO SANTA MARGARITA","CityAbbreviation":"RCHO STA MARG","State":"CA","Zip5":"92688","Zip4":"2014","DeliveryPoint":"83","CarrierRoute":"C057","Footnotes":"N","DPVConfirmation":"Y","DPVCMRA":"N","DPVFootnotes":"AABB","Business":"Y","CentralDeliveryPoint":"N","Vacant":"N"}}';
        System.assertEquals(expected, json);
    }

    @IsTest
    public static void parsesXmlToJsonViaApi() {

        String xml = '<AddressValidateResponse><Address ID="0"><Address1>STE K</Address1><Address2>29851 AVENTURA</Address2><City>RANCHO SANTA MARGARITA</City><CityAbbreviation>RCHO STA MARG</CityAbbreviation><State>CA</State><Zip5>92688</Zip5><Zip4>2014</Zip4><DeliveryPoint>83</DeliveryPoint><CarrierRoute>C057</CarrierRoute><Footnotes>N</Footnotes><DPVConfirmation>Y</DPVConfirmation><DPVCMRA>N</DPVCMRA><DPVFootnotes>AABB</DPVFootnotes><Business>Y</Business><CentralDeliveryPoint>N</CentralDeliveryPoint><Vacant>N</Vacant></Address></AddressValidateResponse>';
        String json = XmlApi.convertXmlToJson(xml);
        String expected = '{"Address":{"Address1":"STE K","Address2":"29851 AVENTURA","City":"RANCHO SANTA MARGARITA","CityAbbreviation":"RCHO STA MARG","State":"CA","Zip5":"92688","Zip4":"2014","DeliveryPoint":"83","CarrierRoute":"C057","Footnotes":"N","DPVConfirmation":"Y","DPVCMRA":"N","DPVFootnotes":"AABB","Business":"Y","CentralDeliveryPoint":"N","Vacant":"N"}}';
        System.assertEquals(expected, json);
    }

    @IsTest
    public static void givenXmlEnvelopeThenConvertsToJsonStructure() {
        String xml = '<foo><test>value</test><test>value 2</test><test>value 3</test><nest><foo>foo str</foo><bar>1</bar></nest></foo>';
        String json = XmlUtil.convertXmlToJson(xml);
        //Serialization does not guarantee order, must validate against elements.
        System.assertEquals(true, json.contains('"nest":{'), 'Does not contain expected element.');
        System.assertEquals(true, json.contains('"bar":"1"'), 'Does not contain expected element.');
        System.assertEquals(true, json.contains('"foo":"foo str"'), 'Does not contain expected element.');
        System.assertEquals(true, json.contains('"test":['), 'Does not contain expected element.');
        System.assertEquals(true, json.contains('"value 2"'), 'Does not contain expected element.');
        System.assertEquals(true, json.contains('"value 3"'), 'Does not contain expected element.');
    }

    @IsTest
    public static void givenXmlEnvelopeThenConvertsToMap() {
        String xml = '<foo><test>value</test><test>value 2</test><nest><foo>foo str</foo><bar>1</bar></nest></foo>';
        Map<String, Object> result = XmlUtil.parse(xml);
        System.assertEquals(new Map<String, Object>{
            'bar' => '1', 'foo' => 'foo str'
        }, result.get('nest'));

        System.assertEquals(new List<Object>{
            'value', 'value 2'
        }, result.get('test'));
    }

 @IsTest
    public static void givenXmlEnvelopeThenConvertsToMapViaApi() {
        String xml = '<foo><test>value</test><test>value 2</test><nest><foo>foo str</foo><bar>1</bar></nest></foo>';
        Map<String, Object> result = XmlApi.parse(xml);
        System.assertEquals(new Map<String, Object>{
            'bar' => '1', 'foo' => 'foo str'
        }, result.get('nest'));

        System.assertEquals(new List<Object>{
            'value', 'value 2'
        }, result.get('test'));
    }


}