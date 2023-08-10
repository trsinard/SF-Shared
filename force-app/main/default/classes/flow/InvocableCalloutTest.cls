/**
 * @author Timothy Sinard
 *
 */
@IsTest
public class InvocableCalloutTest {

    @IsTest
    public static void executesCalloutGivenInvocableRequest() {

        String expectedResponse = '{"response":"success"}';
        HttpMock mock = new HttpMock(expectedResponse, 200);
        Test.setMock(HttpCalloutMock.class, mock);
        Test.startTest();

        InvocableCallout.Request request = new InvocableCallout.Request();
        request.namedCredential = 'NAMED_CREDENTIAL';
        request.path = '/relative';
        request.httpMethod = 'POST';
        request.headerJson = '{"scope": "test"}';
        request.parametersJson = '{"param1": 1, "param2":"foo"}';
        request.bodyJson = '{"body":"fubar"}';
        List<InvocableCallout.Result> results = InvocableCallout.execute(new List<InvocableCallout.Request>{
            request
        });

        Test.stopTest();

        System.assertEquals(1, results.size());
        System.assertEquals(expectedResponse, results.get(0).body);
        mock.assertMethod('POST');
        mock.assertRequestHeader('scope', 'test');
        mock.assertEndpoint('callout:NAMED_CREDENTIAL/relative?param1=1&param2=foo');
        mock.assertRequestBody('{"body":"fubar"}');
    }

    @IsTest
    public static void handlesErrorWhenSubmittingRequest() {

        Test.startTest();

        InvocableCallout.Request request = new InvocableCallout.Request();
        request.headerJson = '{bad}';
        InvocableCallout.Request request2 = new InvocableCallout.Request();
        request2.headerJson = '{bad}';
        List<InvocableCallout.Result> results = InvocableCallout.execute(new List<InvocableCallout.Request>{
            request,
            request2
        });

        Test.stopTest();

        System.assertEquals(2, results.size());
        System.assertEquals(null, results.get(0).body);
        System.assertEquals('Invalid JSON format in configuration.', results.get(0).error);
    }
}