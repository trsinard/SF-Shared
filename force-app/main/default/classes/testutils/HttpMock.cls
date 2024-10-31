@IsTest
public with sharing class HttpMock implements HttpCalloutMock {

    private HttpResponse response;
    private HttpRequest request;
    private Boolean calloutException;
    public HttpMock(Integer statusCode, String status, String body) {
        this.calloutException = false;
        this.response = new HttpResponse();
        this.response.setHeader('Content-Type', 'application/json');
        if(String.isNotBlank(body)) {
            this.response.setBody(body);
        }
        this.response.setStatusCode(statusCode);
        this.response.setStatus(status);
    }


    public HttpMock calloutException(Boolean should) {
        calloutException = should;
        return this;
    }


    public HttpResponse respond(HttpRequest req) {
        System.debug('test '+ this.response);
        if (calloutException) {
            throw new CalloutException();
        }
        this.request = req;
        return this.response;
    }

    public HttpMock assertRequestHeader(String header, String val) {
        System.assertEquals(val, request.getHeader(header));
        return this;
    }

    public HttpMock assertEndpoint(String expected) {
        System.assertEquals(expected, request.getEndpoint());
        return this;
    }
    public HttpMock assertMethod(String expected) {
        System.assertEquals(expected, request.getMethod());
        return this;
    }
    public HttpMock assertRequestBody(String expected) {
        System.assertEquals(expected, request.getBody());
        return this;
    }
}