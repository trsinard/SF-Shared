/**
 * @author Timothy Sinard
 *
 */
@IsTest
public class UspsResponseTest {

    @IsTest
    public static void givenXmlThenBuildsAddress() {

        String xml = '<AddressValidateResponse><Address ID="0"><Address1>STE K</Address1><Address2>29851 AVENTURA</Address2><City>RANCHO SANTA MARGARITA</City><CityAbbreviation>RCHO STA MARG</CityAbbreviation><State>CA</State><Zip5>92688</Zip5><Zip4>2014</Zip4><DeliveryPoint>83</DeliveryPoint><CarrierRoute>C057</CarrierRoute><Footnotes>N</Footnotes><DPVConfirmation>Y</DPVConfirmation><DPVCMRA>N</DPVCMRA><DPVFootnotes>AABB</DPVFootnotes><Business>Y</Business><CentralDeliveryPoint>N</CentralDeliveryPoint><Vacant>N</Vacant></Address></AddressValidateResponse>';
        UspsResponse response = new UspsResponse(xml);
        System.assertEquals('29851 AVENTURA', response.getAddress().getAddress1());
        System.assertEquals('STE K', response.getAddress().getAddress2());
        System.assertEquals('RANCHO SANTA MARGARITA', response.getAddress().getCity());
        System.assertEquals('CA', response.getAddress().getState());
        System.assertEquals('92688', response.getAddress().getZip5());
        System.assertEquals('2014', response.getAddress().getZip4());

    }

    @IsTest
    public static void givenXmlThenBuildsXml() {

        String xml = '<AddressValidateResponse><Address ID="0"><Address1> STE K</Address1><Address2>29851 AVENTURA</Address2><City>RANCHO SANTA MARGARITA</City><CityAbbreviation>RCHO STA MARG</CityAbbreviation><State>CA</State><Zip5>92688</Zip5><Zip4>2014</Zip4><DeliveryPoint>83</DeliveryPoint><CarrierRoute>C057</CarrierRoute><Footnotes>N</Footnotes><DPVConfirmation>Y</DPVConfirmation><DPVCMRA>N</DPVCMRA><DPVFootnotes>AABB</DPVFootnotes><Business>Y</Business><CentralDeliveryPoint>N</CentralDeliveryPoint><Vacant>N</Vacant></Address></AddressValidateResponse>';
        UspsResponse response = new UspsResponse(xml);
        System.assertEquals(xml, response.getXmlResponse());
    }

    @IsTest
    public static void givenXmlThenBuildsJson() {

        String xml = '<AddressValidateResponse><Address ID="0"><Address1> STE K</Address1><Address2>29851 AVENTURA</Address2><City>RANCHO SANTA MARGARITA</City><CityAbbreviation>RCHO STA MARG</CityAbbreviation><State>CA</State><Zip5>92688</Zip5><Zip4>2014</Zip4><DeliveryPoint>83</DeliveryPoint><CarrierRoute>C057</CarrierRoute><Footnotes>N</Footnotes><DPVConfirmation>Y</DPVConfirmation><DPVCMRA>N</DPVCMRA><DPVFootnotes>AABB</DPVFootnotes><Business>Y</Business><CentralDeliveryPoint>N</CentralDeliveryPoint><Vacant>N</Vacant></Address></AddressValidateResponse>';
        UspsResponse response = new UspsResponse(xml);
        System.assertEquals('{"Address":{"Address1":" STE K","Address2":"29851 AVENTURA","City":"RANCHO SANTA MARGARITA","CityAbbreviation":"RCHO STA MARG","State":"CA","Zip5":"92688","Zip4":"2014","DeliveryPoint":"83","CarrierRoute":"C057","Footnotes":"N","DPVConfirmation":"Y","DPVCMRA":"N","DPVFootnotes":"AABB","Business":"Y","CentralDeliveryPoint":"N","Vacant":"N"}}', response.getJsonResponse());
    }
}