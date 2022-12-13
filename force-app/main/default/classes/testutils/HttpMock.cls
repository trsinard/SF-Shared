/**
 * @author Timothy Sinard
 *
 */
@IsTest
public class HttpMock implements HttpCalloutMock {

    private HttpRequest request;
    private HttpResponse response;

    public HttpMock(String body, Integer statusCode) {
        this.response = new HttpResponse();
        this.response.setStatusCode(statusCode);
        this.response.setHeader('Content-Type', 'application/json');
        if (body != null) {
            this.response.setBody(body);
        }
    }

    public HttpResponse respond(HttpRequest req) {
        this.request = req;
        return this.response;

    }

    public HttpMock assertMethod(String expected) {
        System.assertEquals(expected, request.getMethod());
        return this;
    }

    public HttpMock assertEndpoint(String expected) {
        System.assertEquals(expected, request.getEndpoint());
        return this;
    }

    public HttpMock assertRequestBody(String expected) {
        System.assertEquals(expected, request.getBody());
        return this;
    }

    public HttpMock assertRequestBodyJson(String expected) {
        System.assertEquals(JSON.deserializeUntyped(expected), JSON.deserializeUntyped(request.getBody()));
        return this;
    }

    public HttpMock assertRequestHeader(String header, String val) {
        System.assertEquals(val, request.getHeader(header));
        return this;
    }

}