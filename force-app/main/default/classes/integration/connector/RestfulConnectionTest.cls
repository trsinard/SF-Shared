/**
 * @author Timothy Sinard
 *
 */
@IsTest
public class RestfulConnectionTest {

    @IsTest
    public static void executesExpectedGetRequest() {

        String expectedResponse = '{"response":"success"}';
        HttpMock mock = new HttpMock(200, 'Success', expectedResponse);
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
        RestfulConnection connection = new RestfulConnection('NAMED_CREDENTIAL');
        String actualResponse = connection.executeGet('/relative', new Map<String, String>{
            'TEST' => 'value'
        }, new Map<String, String>{
            'param1' => 'foobar'
        });

        Test.stopTest();

        System.assertEquals(expectedResponse, actualResponse);
        mock.assertMethod('GET');
        mock.assertRequestHeader('TEST', 'value');
        mock.assertEndpoint('callout:NAMED_CREDENTIAL/relative?param1=foobar');
        mock.assertRequestBody('');
    }

    @IsTest
    public static void tracksHistoryForCalls() {

        TestableDatetime.setNow(Datetime.newInstance(2024, 09, 06, 03, 23, 20));
        String expectedResponse = '{"response":"success"}';
        HttpMock mock = new HttpMock(200, 'Success', expectedResponse);
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
        RestfulConnection connection = new RestfulConnection('NAMED_CREDENTIAL');
        connection.executeGet('/relative', new Map<String, String>{
            'TEST' => 'value'
        }, new Map<String, String>{
            'param1' => 'foobar'
        });

        Test.stopTest();

        List<RestfulConnection.CallHistory> result = connection.getHistory();
        System.assertEquals(1, result.size());
        HttpRequest theRequest = result.get(0).getRequest();
        HttpResponse theResponse = result.get(0).getResponse();
        System.assertEquals(Datetime.newInstance(2024, 09, 06, 03, 23, 20), result.get(0).getDatetime());
        System.assertEquals('', theRequest.getBody());
        System.assertEquals('GET', theRequest.getMethod());
        System.assertEquals('callout:NAMED_CREDENTIAL/relative?param1=foobar', theRequest.getEndpoint());
        System.assertEquals('Success', theResponse.getStatus());
        System.assertEquals(200, theResponse.getStatusCode());
        System.assertEquals(expectedResponse, theResponse.getBody());
    }


    @IsTest
    public static void skipsHistoryTrackingForCallsWhenDisabled() {

        TestableDatetime.setNow(Datetime.newInstance(2024, 09, 06, 03, 23, 20));
        String expectedResponse = '{"response":"success"}';
        HttpMock mock = new HttpMock(200, 'Success', expectedResponse);
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
        RestfulConnection connection = new RestfulConnection('NAMED_CREDENTIAL');
        connection.disableHistoryTracking();
        connection.executeGet('/relative', new Map<String, String>{
            'TEST' => 'value'
        }, new Map<String, String>{
            'param1' => 'foobar'
        });

        Test.stopTest();

        List<RestfulConnection.CallHistory> result = connection.getHistory();
        System.assertEquals(0, result.size());
    }

    @IsTest
    public static void executesExpectedPostRequest() {

        String expectedResponse = '{"response":"success"}';
        HttpMock mock = new HttpMock(200, 'Success', expectedResponse);
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
        RestfulConnection connection = new RestfulConnection('NAMED_CREDENTIAL');
        String actualResponse = connection.executePost('/relative', new Map<String, String>{
            'TEST' => 'value'
        }, new Map<String, Object>{
            'body' => 'fubar'
        });

        Test.stopTest();

        System.assertEquals(expectedResponse, actualResponse);
        mock.assertMethod('POST');
        mock.assertRequestHeader('TEST', 'value');
        mock.assertEndpoint('callout:NAMED_CREDENTIAL/relative');
        mock.assertRequestBody('{"body":"fubar"}');
    }

    @IsTest
    public static void throwsAuthorizationExceptionWith403() {

        String expectedResponse = 'Forbidden';
        HttpMock mock = new HttpMock(403, 'Unauthorized', expectedResponse);
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
        RestfulConnection connection = new RestfulConnection('NAMED_CREDENTIAL');

        Boolean error = false;
        try {
            connection.executeGetOnPath('/relative');
        } catch (AuthorizationException e) {
            error = true;
        }
        System.assertEquals(true, error, 'Expected Authorization Exception.');

        Test.stopTest();
        mock.assertMethod('GET');
        mock.assertEndpoint('callout:NAMED_CREDENTIAL/relative');
        mock.assertRequestBody('');
    }

    @IsTest
    public static void convertsMapToUrlParameters() {

        RestfulConnection connection = new RestfulConnection('NAMED_CREDENTIAL');

        Map<String, Object> mixedMap = null;
        String results = connection.convertMapToUrlParameters(mixedMap);
        System.assertEquals('', results);

        mixedMap = new Map<String, Object>{
            'param1' => 5,
            'param2' => true,
            'param3' => 'foo',
            'param4' => 1.40
        };

        results = connection.convertMapToUrlParameters(mixedMap);
        System.assertEquals('?param1=5&param2=true&param3=foo&param4=1.40', results);

    }

    @IsTest
    public static void returnsSuccessFromStatusResponseBody() {

        RestfulConnection connection = new RestfulConnection('NAMED_CREDENTIAL');
        System.assertEquals(true, connection.isSuccess('{"status":200}'));
        System.assertEquals(true, connection.isSuccess('{"status":201}'));
        System.assertEquals(true, connection.isSuccess('{"status":203}'));
        System.assertEquals(true, connection.isSuccess('{"status":250}'));
        System.assertEquals(true, connection.isSuccess('{"status":299}'));

    }

    @IsTest
    public static void returnsNotSuccessFromStatusResponseBody() {
        RestfulConnection connection = new RestfulConnection('NAMED_CREDENTIAL');
        System.assertEquals(false, connection.isSuccess('{"status":500}'));
        System.assertEquals(false, connection.isSuccess('{"status":404}'));
        System.assertEquals(false, connection.isSuccess('{"status":4002}'));
        System.assertEquals(false, connection.isSuccess('{}'));
    }

    @IsTest
    public static void retrievesCachedConnectionByNamedCredential() {

        RestfulConnection connection1 = RestfulConnection.getConnection('NAMED_CREDENTIAL');
        RestfulConnection connection2 = RestfulConnection.getConnection('NAMED_CREDENTIAL2');
        RestfulConnection connection3 = RestfulConnection.getConnection('NAMED_CREDENTIAL');
        System.assertNotEquals(connection1, connection2);
        System.assertNotEquals(connection3, connection2);
        System.assertEquals(connection1, connection3);

    }

}