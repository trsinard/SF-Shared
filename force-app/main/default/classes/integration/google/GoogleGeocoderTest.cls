/**
 * @author Timothy Sinard
 *
 */

@IsTest
public class GoogleGeocoderTest {

    @IsTest
    public static void givenAddressThenHandlesSuccessfulRequest() {

        String expectedResponse = '{"results": [{"address_components": [{"long_name": "1600","short_name": "1600","types": ["street_number"]},{"long_name": "Amphitheatre Parkway","short_name": "Amphitheatre Pkwy","types": ["route"]},{"long_name": "Mountain View","short_name": "Mountain View","types": ["locality","political"]},{"long_name": "Santa Clara County","short_name": "Santa Clara County","types": ["administrative_area_level_2","political"]},{"long_name": "California","short_name": "CA","types": ["administrative_area_level_1","political"]},{"long_name": "United States","short_name": "US","types": ["country","political"]},{"long_name": "94043","short_name": "94043","types": ["postal_code"]}],"formatted_address": "1600 Amphitheatre Pkwy, Mountain View, CA 94043, USA","geometry": {"location": {"lat": 37.4267861,"lng": -122.0806032},"location_type": "ROOFTOP","viewport": {"northeast": {"lat": 37.4281350802915,"lng": -122.0792542197085},"southwest": {"lat": 37.4254371197085,"lng": -122.0819521802915}}},"place_id": "ChIJtYuu0V25j4ARwu5e4wwRYgE","plus_code": {"compound_code": "CWC8+R3 Mountain View, California, United States","global_code": "849VCWC8+R3"},"types": ["street_address"]}],"status": "OK"}';
        HttpMock mock = new HttpMock(expectedResponse, 200);
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
        GoogleGeocoder service = new GoogleGeocoder('api_key_1100');
        Location results = service.getCoordinatesFromAddress('1600 Amphitheatre Parkway, Mountain View, CA');
        Test.stopTest();

        System.assertEquals(37.4267861, results.getLatitude());
        System.assertEquals(-122.0806032, results.getLongitude());
        mock.assertMethod('GET');
        mock.assertEndpoint('callout:GoogleAPI/maps/api/geocode/json?address=1600+Amphitheatre+Parkway%2C+Mountain+View%2C+CA&key=api_key_1100');
    }

    @IsTest
    public static void givenAddressThenGracefullyHandleError() {

        String expectedResponse = '{"missing":"no-details"}';
        HttpMock mock = new HttpMock(expectedResponse, 200);
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
        GoogleGeocoder service = new GoogleGeocoder('api_key_1100');
        Location results = service.getCoordinatesFromAddress('1600 Amphitheatre Parkway, Mountain View, CA');
        Test.stopTest();
        System.assertEquals(null, results.getLatitude());
        System.assertEquals(null, results.getLongitude());
    }


    @IsTest
    public static void givenBlankAddressThenSkipsCallout() {

        Test.startTest();
        GoogleGeocoder service = new GoogleGeocoder('api_key_1100');
        Location results = service.getCoordinatesFromAddress('');
        Test.stopTest();
        System.assertEquals(null, results.getLatitude());
        System.assertEquals(null, results.getLongitude());
    }


}