/**
 * @author Timothy Sinard
 *
 */
@IsTest
public class UspsShippingServiceTest {

    @IsTest
    public static void throwsErrorWhenInvalidParameter() {

        Boolean error = false;
        try {
            UspsShippingService service = new UspsShippingService(null);
        } catch (InvalidParameterException e) {
            System.assertEquals('Invalid key for USPS Shipping API.', e.getMessage());
            error = true;
        }
        System.assertEquals(true, error, 'Expected InvalidParameterException');
    }

    @IsTest
    public static void givenAddressThenBuildsXmlRequest() {

        UspsShippingService service = new UspsShippingService('USER_KEY');
        String actual = service.buildVerifyRequest('29851 aVeNtuRa', 'Ste K', 'Rancho Santa Marg', 'california', '92688', null);
        String expected = '<?xml version="1.0" encoding="UTF-8"?><AddressValidateRequest USERID="USER_KEY"><Address ID="0"><Address1>29851 aVeNtuRa</Address1><Address2>Ste K</Address2><City>Rancho Santa Marg</City><State>california</State><Zip5>92688</Zip5><Zip4></Zip4></Address></AddressValidateRequest>';
        System.assertEquals(expected, actual);
    }

    @IsTest
    public static void givenAddressToVerifyThenParsesResponse() {

        String response = '<AddressValidateResponse><Address ID="0"><Address1>STE K</Address1><Address2>29851 AVENTURA</Address2><City>RANCHO SANTA MARGARITA</City><CityAbbreviation>RCHO STA MARG</CityAbbreviation><State>CA</State><Zip5>92688</Zip5><Zip4>2014</Zip4><DeliveryPoint>83</DeliveryPoint><CarrierRoute>C057</CarrierRoute><Footnotes>N</Footnotes><DPVConfirmation>Y</DPVConfirmation><DPVCMRA>N</DPVCMRA><DPVFootnotes>AABB</DPVFootnotes><Business>Y</Business><CentralDeliveryPoint>N</CentralDeliveryPoint><Vacant>N</Vacant></Address></AddressValidateResponse>';
        HttpMock mock = new HttpMock(response, 200);
        Test.setMock(HttpCalloutMock.class, mock);

        Test.startTest();
        UspsShippingService service = new UspsShippingService('USER_KEY');
        Address result = service.verify('29851 aVeNtuRa', 'Ste K', 'Rancho Santa Marg', 'california', '92688');
        Test.stopTest();

        System.assertEquals('29851 AVENTURA', result.getAddress1());
        System.assertEquals('STE K', result.getAddress2());
        System.assertEquals('RANCHO SANTA MARGARITA', result.getCity());
        System.assertEquals('CA', result.getState());
        System.assertEquals('92688', result.getZip5());
        System.assertEquals('2014', result.getZip4());
        mock.assertMethod('GET');
        mock.assertEndpoint('callout:Usps/ShippingAPI.dll?API=Verify&XML=%3C%3Fxml+version%3D%221.0%22+encoding%3D%22UTF-8%22%3F%3E%3CAddressValidateRequest+USERID%3D%22USER_KEY%22%3E%3CAddress+ID%3D%220%22%3E%3CAddress1%3E29851+aVeNtuRa%3C%2FAddress1%3E%3CAddress2%3ESte+K%3C%2FAddress2%3E%3CCity%3ERancho+Santa+Marg%3C%2FCity%3E%3CState%3Ecalifornia%3C%2FState%3E%3CZip5%3E92688%3C%2FZip5%3E%3CZip4%3E%3C%2FZip4%3E%3C%2FAddress%3E%3C%2FAddressValidateRequest%3E');
        mock.assertRequestBody('');
    }
}