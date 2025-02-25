/**
 * @author Timothy Sinard
 *
 */
public class UspsShippingService extends RestfulConnection {

    private final String USPS_SHIPPING_API = '/ShippingAPI.dll';
    private String apiKey;

    public UspsShippingService() {
        super('Usps');
    }

    public UspsShippingService(String apiKey) {
        this();
        this.apiKey = apiKey;
        if (String.isBlank(this.apiKey)) {
            throw new InvalidParameterException('Invalid key for USPS Shipping API.');
        }
    }

    public Address verify(String address1, String address2, String city, String state, String zip) {
        String request = buildVerifyRequest(address1, address2, city, state, zip, null);
        UspsResponse response = new UspsResponse(executeGet(USPS_SHIPPING_API + '?API=Verify&XML=' + EncodingUtil.urlEncode(request, 'UTF-8'), null, null));
        return response.getAddress();
    }

    @TestVisible
    private String buildVerifyRequest(String address1, String address2, String city, String state, String zip5, String zip4) {
        Dom.Document document = new Dom.Document();
        Dom.XmlNode requestNode = document.createRootElement('AddressValidateRequest', null, null);
        requestNode.setAttribute('USERID', apiKey);

        Dom.XmlNode addressNode = requestNode.addChildElement('Address', null, null);
        addressNode.setAttribute('ID', '0');
        addressNode.addChildElement('Address1', null, null).addTextNode(BetterString.valueOf(address1, true));
        addressNode.addChildElement('Address2', null, null).addTextNode(BetterString.valueOf(address2, true));
        addressNode.addChildElement('City', null, null).addTextNode(BetterString.valueOf(city, true));
        addressNode.addChildElement('State', null, null).addTextNode(BetterString.valueOf(state, true));
        addressNode.addChildElement('Zip5', null, null).addTextNode(BetterString.valueOf(zip5, true));
        addressNode.addChildElement('Zip4', null, null).addTextNode(BetterString.valueOf(zip4, true));
        return document.toXmlString();

    }

}