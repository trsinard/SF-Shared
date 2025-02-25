/**
 * @author Timothy Sinard
 *
 */
@IsTest
public class AddressTest {

    @IsTest
    public static void buildsModelThenRetrievesValues() {

        Address address = new Address()
            .setAddress1('123 Sesame Street')
            .setAddress2('Suite 1')
            .setCity('City')
            .setState('TN')
            .setZip5('12345')
            .setZip4('6789');

        System.assertEquals('123 Sesame Street', address.getAddress1());
        System.assertEquals('Suite 1', address.getAddress2());
        System.assertEquals('City', address.getCity());
        System.assertEquals('TN', address.getState());
        System.assertEquals('12345', address.getZip5());
        System.assertEquals('6789', address.getZip4());
    }
}