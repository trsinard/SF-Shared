@IsTest
public with sharing class HttpMock implements HttpCalloutMock {

    private class Packet {
        private final HttpResponse response;
        private HttpRequest request;
        private Boolean calloutException;
        private Packet(Integer statusCode, String status, String body) {
            this.calloutException = false;
            this.response = new HttpResponse();
            this.response.setHeader('Content-Type', 'application/json');
            if (String.isNotBlank(body)) {
                this.response.setBody(body);
            }
            this.response.setStatusCode(statusCode);
            this.response.setStatus(status);
        }
    }
    @TestVisible
    private final Map<String, Packet> MOCKS = new Map<String, Packet>();


    public HttpMock() {

    }
    public HttpMock(Integer statusCode, String status, String body) {
        this();
        this.mock(statusCode, status, body);
    }

    private Packet getPacket(HttpRequest req) {
        return getPacket(req.getMethod(), req.getEndpoint(), true);
    }

    private Packet getPacket(String method, String endpoint) {
        return getPacket(method, endpoint, true);
    }

    private Packet getPacket(String method, String endpoint, Boolean fallback) {
        Packet packet = MOCKS.get(method.toUpperCase().trim() + ':' + endpoint.toLowerCase().trim());
        if (packet == null && fallback) {
            packet = MOCKS.get(':');
        }
        return packet;
    }

    @TestVisible
    private HttpMock mock(Integer statusCode, String status, String body) {
        return mock('', '', statusCode, status, body, false);
    }

    @TestVisible
    private HttpMock mock(String httpMethod, String path, Integer statusCode, String status, String body) {
        return mock(httpMethod, path, statusCode, status, body, false);
    }

    @TestVisible
    private HttpMock mock(String httpMethod, String path, Integer statusCode, String status, String body, Boolean calloutException) {
        Packet packet = new Packet(statusCode, status, body);
        packet.calloutException = calloutException;
        MOCKS.put(httpMethod.toUpperCase().trim() + ':' + path.toLowerCase().trim(), packet);
        return this;
    }

    public HttpResponse respond(HttpRequest req) {
        Packet packet = getPacket(req);
        if (packet.calloutException) {
            throw new CalloutException();
        }
        packet.request = req;
        return packet.response;
    }

    public HttpMock assertRequestBody(String httpMethod, String endpoint, String expected) {
        System.assertEquals(expected, getPacket(httpMethod, endpoint, false)?.request?.getBody());
        return this;
    }
    public HttpMock assertRequestBody(String expected) {
        System.assertEquals(expected, MOCKS.get(':')?.request?.getBody());
        return this;
    }

    public HttpMock assertMethod(String expected) {
        System.assertEquals(expected, MOCKS.get(':')?.request?.getMethod());
        return this;
    }

    public HttpMock assertEndpoint(String expected) {
        System.assertEquals(expected, MOCKS.get(':')?.request?.getEndpoint());
        return this;
    }

    public HttpMock assertRequestHeader(String header, String val) {
        System.assertEquals(val,  MOCKS.get(':')?.request?.getHeader(header));
        return this;
    }
}