/**
 * @author Timothy Sinard
 *
 */
public class InvocableCallout {

    public class Request {
        @InvocableVariable(Required=true Label='Named Credential')
        public String namedCredential;

        @InvocableVariable(Label='Path')
        public String path;

        @InvocableVariable(Required=true Label='Method' Description='GET/POST/PUT/PATCH/DELETE')
        public String httpMethod;

        @InvocableVariable(Label='Headers (JSON)' Description='JSON')
        public String headerJson;

        @InvocableVariable(Label='Parameters (JSON)' Description='JSON')
        public String parametersJson;

        @InvocableVariable(Label='Body (JSON)' Description='JSON')
        public String bodyJson;
    }

    public class Result {
        @InvocableVariable(Label='JSON Body')
        public String body;

        @InvocableVariable(Label='error')
        public String error;

    }

    @InvocableMethod(Label='Callout: Generic Request' Description='Executes callout on Named Credential given configuration.')
    public static List<Result> execute(List<Request> requests) {
        List<Result> results = new List<Result>();

        for (Request request : requests) {
            results.add(execute(request));
        }
        return results;
    }

    private static Result execute(Request request) {
        Result result = new Result();
        try {
            RestfulConnection connection = RestfulConnection.getConnection(request.namedCredential);
            result.body = connection.executeCallout(
                request.path,
                request.httpMethod,
                String.isBlank(request.headerJson) ? null : (Map<String, Object>) JSON.deserializeUntyped(request.headerJson),
                String.isBlank(request.parametersJson) ? null : (Map<String, Object>) JSON.deserializeUntyped(request.parametersJson),
                request.bodyJson).getBody();
        } catch (Exception e) {
            String error = e.getMessage();
            if (e instanceof JSONException) {
                error = 'Invalid JSON format in configuration.';
            }
            result.error = error;
            System.debug(e.getMessage());
        }
        return result;
    }

}