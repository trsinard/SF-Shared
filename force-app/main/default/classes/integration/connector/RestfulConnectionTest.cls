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
    public static void executesExpectedDeleteRequest() {

        String expectedResponse = '{"response":"success"}';
        HttpMock mock = new HttpMock(200, 'Success', expectedResponse);
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
        RestfulConnection connection = new RestfulConnection('NAMED_CREDENTIAL');
        String actualResponse = connection.executeDelete('/relative', new Map<String, String>{
            'TEST' => 'value'
        }, new Map<String, String>{
            'param1' => 'foobar'
        }).getBody();

        Test.stopTest();

        System.assertEquals(expectedResponse, actualResponse);
        mock.assertMethod('DELETE');
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
        }, JSON.serialize(new Map<String, Object>{
            'body' => 'fubar'
        })).getBody();

        Test.stopTest();

        System.assertEquals(expectedResponse, actualResponse);
        mock.assertMethod('POST');
        mock.assertRequestHeader('TEST', 'value');
        mock.assertEndpoint('callout:NAMED_CREDENTIAL/relative');
        mock.assertRequestBody('{"body":"fubar"}');
    }

    @IsTest
    public static void executesExpectedPutRequest() {

        String expectedResponse = '{"response":"success"}';
        HttpMock mock = new HttpMock(200, 'Success', expectedResponse);
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
        RestfulConnection connection = new RestfulConnection('NAMED_CREDENTIAL');
        String actualResponse = connection.executePut('/relative', new Map<String, String>{
            'TEST' => 'value'
        }, JSON.serialize(new Map<String, Object>{
            'body' => 'fubar'
        })).getBody();

        Test.stopTest();

        System.assertEquals(expectedResponse, actualResponse);
        mock.assertMethod('PUT');
        mock.assertRequestHeader('TEST', 'value');
        mock.assertEndpoint('callout:NAMED_CREDENTIAL/relative');
        mock.assertRequestBody('{"body":"fubar"}');
    }

    @IsTest
    public static void executesExpectedPatchRequest() {

        String expectedResponse = '{"response":"success"}';
        HttpMock mock = new HttpMock(200, 'Success', expectedResponse);
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
        RestfulConnection connection = new RestfulConnection('NAMED_CREDENTIAL');
        String actualResponse = connection.executePatch('/relative', new Map<String, String>{
            'TEST' => 'value'
        }, new Map<String, String>{
            'param1' => 'foobar'
        }, JSON.serialize(new Map<String, Object>{
            'body' => 'fubar'
        })).getBody();

        Test.stopTest();

        System.assertEquals(expectedResponse, actualResponse);
        mock.assertMethod('PATCH');
        mock.assertRequestHeader('TEST', 'value');
        mock.assertEndpoint('callout:NAMED_CREDENTIAL/relative?param1=foobar');
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
            connection.executeGet('/relative');
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
    public static void setsTimeout() {
        RestfulConnection connection = new RestfulConnection('NAMED_CREDENTIAL');
        connection.setTimeout(100);
        System.assertEquals(100, connection.getTimeout());
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
    public static void returnsSuccessFromResponse() {
        String expectedResponse = '{"response":"success"}';
        HttpMock mock = new HttpMock(200, 'Success', expectedResponse);
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
        RestfulConnection connection = new RestfulConnection('NAMED_CREDENTIAL');
        HttpResponse response = connection.executePost('/relative', new Map<String, String>(), null);
        Test.stopTest();
        System.assertEquals(true, connection.isSuccess(response));
    }

    @IsTest
    public static void returnsNotSuccessFromResponse() {
        String expectedResponse = '{}';
        HttpMock mock = new HttpMock(400, 'Success', expectedResponse);
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();
        RestfulConnection connection = new RestfulConnection('NAMED_CREDENTIAL');
        HttpResponse response = connection.executePost('/relative', new Map<String, String>(), null);
        Test.stopTest();
        System.assertEquals(false, connection.isSuccess(response));
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