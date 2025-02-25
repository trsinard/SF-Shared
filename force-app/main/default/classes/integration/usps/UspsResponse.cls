/**
 * @author Timothy Sinard
 *
 */
public class UspsResponse {

    private String xml;
    private String asJson;
    private Address address;
    public UspsResponse(String xml) {
        this.xml = xml;
        this.asJson = XmlUtil.convertXmlToJson(xml);
        this.address = new Address()
            .setAddress1(BetterString.valueOf(JsonUtil.valueFromPath(asJson, 'Address.Address2'))) //USPS flips Address 1 & 2
            .setAddress2(BetterString.valueOf(JsonUtil.valueFromPath(asJson, 'Address.Address1')))
            .setCity(BetterString.valueOf(JsonUtil.valueFromPath(asJson, 'Address.City')))
            .setState(BetterString.valueOf(JsonUtil.valueFromPath(asJson, 'Address.State')))
            .setZip5(BetterString.valueOf(JsonUtil.valueFromPath(asJson, 'Address.Zip5')))
            .setZip4(BetterString.valueOf(JsonUtil.valueFromPath(asJson, 'Address.Zip4')));
    }

    public String getXmlResponse() {
        return this.xml;
    }

    public String getJsonResponse() {
        return this.asJson;
    }

    public Address getAddress() {
        return this.address;
    }
}