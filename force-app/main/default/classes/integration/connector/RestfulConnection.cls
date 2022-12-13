/**
 * @author Timothy Sinard
 *
 */
public virtual class RestfulConnection {

    protected String namedCredential;

    private static Map<String, RestfulConnection> cachedConnections = new Map<String, RestfulConnection>();

    public RestfulConnection(String namedCredential) {
        this.namedCredential = namedCredential;
        RestfulConnection.cachedConnections.put(namedCredential, this);
    }

    public static RestfulConnection getConnection(String namedCredential) {
        RestfulConnection connection = RestfulConnection.cachedConnections.get(namedCredential);
        if (connection == null) {
            connection = new RestfulConnection(namedCredential);
            RestfulConnection.cachedConnections.put(namedCredential, connection);
        }
        return connection;
    }

    @TestVisible
    protected virtual String executeGetOnPath(String path) {
        return executeGet(path, null, null);
    }

    @TestVisible
    protected virtual String executeGet(String path, Map<String, String> headers, Map<String, Object> parameters) {
        return executeCallout(path, 'GET', headers, parameters, null).getBody();
    }

    @TestVisible
    protected virtual String executePost(String path, Map<String, String> headers, String body) {
        return executePostForResponse(path, headers, body).getBody();
    }

    @TestVisible
    protected HttpResponse executePostForResponse(String path, Map<String, String> headers, String body) {
        headers = headers == null ? new Map<String, String>() : headers;
        headers.put('Content-Type', 'application/json');
        headers.put('Accept', 'application/json');
        HttpResponse response = executeCallout(path, 'POST', headers, body);
        return response;
    }

    public HttpResponse executeCallout(String path, String httpMethod, Map<String, Object> headers, Map<String, Object> parameters, String body) {
        path += convertMapToUrlParameters(parameters);
        headers = headers == null ? new Map<String, String>() : headers;
        return executeCallout(path, httpMethod, headers, body);

    }

    private HttpResponse executeCallout(String path, String httpMethod, Map<String, Object> headers, String body) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:' + this.namedCredential + path);
        req.setMethod(httpMethod);
        if (body != null) {
            req.setBody(body);
        }
        if (headers.size() > 0) {
            for (String header : headers.keySet()) {
                req.setHeader(header, BetterString.valueOf(headers.get(header)));
            }
        }
        Http http = new Http();
        HttpResponse response = http.send(req);
        if (response.getStatusCode() == 403) {
            throw new AuthorizationException();
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
    protected Boolean isSuccess(String payload) {
        Integer statusCode = JsonUtil.integerFromPath(payload, 'status');
        statusCode = statusCode == null ? 0 : statusCode;
        return statusCode / 100 == 2;

    }
}