/**
 * @author Timothy Sinard
 *
 */
global virtual class RestfulConnection {

    protected String namedCredential;
    private Boolean trackHistory = true;
    private List<CallHistory> history = new List<CallHistory>();

    public class CallHistory {
        private final Datetime dt;
        private final HttpRequest request;
        private final HttpResponse response;
        private CallHistory() {
        }
        public CallHistory(Datetime dt, HttpRequest request, HttpResponse response) {
            this();
            this.dt = dt;
            this.request = request;
            this.response = response;
        }
        public HttpRequest getRequest() {
            return this.request;
        }
        public HttpResponse getResponse() {
            return this.response;
        }
        public Datetime getDatetime() {
            return this.dt;
        }
    }

    private Integer timeout = 10000;

    private static final Map<String, RestfulConnection> cachedConnections = new Map<String, RestfulConnection>();

    global RestfulConnection(String namedCredential) {
        this.enableHistoryTracking();
        this.namedCredential = namedCredential;
        RestfulConnection.cachedConnections.put(namedCredential, this);
    }

    global void disableHistoryTracking() {
        this.trackHistory = false;
    }

    global void setTimeout(Integer num) {
        this.timeout = num;
    }

    global Integer getTimeout() {
        return this.timeout;
    }


    global void enableHistoryTracking() {
        this.trackHistory = true;
    }

    global List<CallHistory> getHistory() {
        return this.history;
    }

    global static RestfulConnection getConnection(String namedCredential) {
        RestfulConnection connection = RestfulConnection.cachedConnections.get(namedCredential);
        if (connection == null) {
            connection = new RestfulConnection(namedCredential);
            RestfulConnection.cachedConnections.put(namedCredential, connection);
        }
        return connection;
    }

    @TestVisible
    protected virtual String executeGet(String path) {
        return executeGet(path, null, null);
    }


    @TestVisible
    protected virtual String executeGet(String path, Map<String, String> headers, Map<String, Object> parameters) {
        return executeCallout(path, 'GET', headers, parameters, null).getBody();
    }

    @TestVisible
    protected virtual HttpResponse executeDelete(String path, Map<String, String> headers, Map<String, Object> parameters) {
        return executeCallout(path, 'DELETE', headers, parameters, null);
    }


    @TestVisible
    protected HttpResponse executePost(String path, Map<String, String> headers, String body) {
        headers = headers == null ? new Map<String, String>() : headers;
        HttpResponse response = executeCallout(path, 'POST', headers, body);
        return response;
    }


    @TestVisible
    protected HttpResponse executePut(String path, Map<String, String> headers, String body) {
        headers = headers == null ? new Map<String, String>() : headers;
        HttpResponse response = executeCallout(path, 'PUT', headers, body);
        return response;
    }



    @TestVisible
    protected HttpResponse executePatch(String path, Map<String, String> headers, Map<String, String> parameters, String body) {
        headers = headers == null ? new Map<String, String>() : headers;
        HttpResponse response = executeCallout(path, 'PATCH', headers, parameters, body);
        return response;
    }

    global HttpResponse executeCallout(String path, String httpMethod, Map<String, Object> headers, Map<String, Object> parameters, String body) {
        path += this.convertMapToUrlParameters(parameters);
        headers = headers == null ? new Map<String, String>() : headers;
        return executeCallout(path, httpMethod, headers, body);

    }

    private HttpResponse executeCallout(String path, String httpMethod, Map<String, Object> headers, String body) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:' + this.namedCredential + path);
        req.setMethod(httpMethod);
        if (this.timeout != null) {
            req.setTimeout(this.timeout);
        }
        if (body != null) {
            req.setBody(body);
        }
        if (headers.size() > 0) {
            for (String header : headers.keySet()) {
                req.setHeader(header, BetterString.valueOf(headers.get(header)));
            }
        }
        Http http = new Http();
        System.debug(LoggingLevel.FINE, 'Executing callout ');
        System.debug(LoggingLevel.FINE, 'REQUEST: ' + JSON.serialize(new Map<String, Object>{
            'METHOD' => req.getMethod(),
            'ENDPOINT' => req.getEndpoint(),
            'HEADERS' => headers,
            'BODY' => body
        }));
        HttpResponse response = http.send(req);
        if (this.trackHistory) {
            this.history.add(new CallHistory(TestableDatetime.now(), req, response));
        }
        System.debug(LoggingLevel.FINE, 'RESPONSE: ' + JSON.serialize(new Map<String, Object>{
            'STATUS' => response.getStatus(),
            'BODY' => response.getBody()
        }));
        if (response.getStatusCode() == 403) {
            throw new AuthorizationException(response.getBody());
        }
        return response;
    }

    @TestVisible
    private String convertMapToUrlParameters(Map<String, Object> parameters) {
        List<String> paramParts = new List<String>();
        if (parameters != null) {
            for (String param : parameters.keySet()) {
                paramParts.add(param + '=' + EncodingUtil.urlEncode(BetterString.valueOf(parameters.get(param), true), 'UTF-8'));
            }
        }
        return (paramParts.size() > 0 ? '?' : '') + String.join(paramParts, '&');
    }

    @TestVisible
    protected Boolean isSuccess(HttpResponse response) {
        Integer statusCode = response.getStatusCode();
        statusCode = statusCode == null ? 0 : statusCode;
        return statusCode / 100 == 2;
    }
}