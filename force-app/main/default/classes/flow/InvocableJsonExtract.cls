/**
 * @author Timothy Sinard
 *
 */

public class InvocableJsonExtract {

    public class Request {
        @InvocableVariable(Label='JSON' Required=true)
        public String json;
        @InvocableVariable(Label='Property Path' Required=true)
        public String propertyPath;

    }

    public class Result {
        @InvocableVariable(Label='Value')
        public String value;
    }

    @InvocableMethod(Label='Extract JSON Value' Description='Extract value by path')
    public static List<Result> extractJsonValue(List<Request> requests) {
        List<Result> results = new List<Result>();
        for (Request request : requests) {
            results.add(extractJsonValue(request));
        }
        return results;
    }

    private static Result extractJsonValue(Request request) {
        Result result = new Result();
        result.value = JsonUtil.stringFromPath(request.json, request.propertyPath);
        System.debug(result.value);
        return result;
    }
}