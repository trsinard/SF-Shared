/**
 * @author Timothy Sinard
 *
 */
public class Address {
    private String address1;
    private String address2;
    private String city;
    private String state;
    private String zip5;
    private String zip4;

    public Address() {
    }

    public String getAddress1() {
        return this.address1;
    }

    public String getAddress2() {
        return this.address2;
    }

    public String getCity() {
        return this.city;
    }

    public String getState() {
        return this.state;
    }

    public String getZip5() {
        return this.zip5;
    }

    public String getZip4() {
        return this.zip4;
    }

    public Address setAddress1(String address) {
        this.address1 = address;
        return this;
    }

    public Address setAddress2(String address) {
        this.address2 = address;
        return this;
    }

    public Address setCity(String city) {
        this.city = city;
        return this;
    }

    public Address setState(String state) {
        this.state = state;
        return this;
    }

    public Address setZip5(String zip) {
        this.zip5 = zip;
        return this;
    }

    public Address setZip4(String zip) {
        this.zip4 = zip;
        return this;
    }
}