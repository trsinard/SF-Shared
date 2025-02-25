/**
 * @author Timothy Sinard
 *
 */
public with sharing class GoogleGeocoder extends RestfulConnection {

    private String apiKey;

    public GoogleGeocoder(String apiKey) {
        super('GoogleAPI');
        this.apiKey = apiKey;
    }

    public Location getCoordinatesFromAddress(String address) {
        Location results = null;
        if (!String.isEmpty(address)) {
            String response = super.executeGet('/maps/api/geocode/json', null, new Map<String, String>{
                'address' => address,
                'key' => this.apiKey
            });

            results = Location.newInstance(Double.valueOf(JsonUtil.valueFromPath(response, 'results[0].geometry.location.lat')), Double.valueOf(JsonUtil.valueFromPath(response, 'results[0].geometry.location.lng')));
        }
        return results;
    }

}