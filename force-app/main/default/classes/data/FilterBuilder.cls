public with sharing class FilterBuilder {

    public final static Operator OP_AND = new Operator('AND');
    public final static Operator OP_OR = new Operator('OR');

    private class Operator {
        private final String value;
        private Operator(String value) {
            this.value = value;
        }
        public override String toString() {
            return this.value;
        }
    }
    private final Operator operator;
    private final Set<String> filters;

    private FilterBuilder() {
        filters = new Set<String>();
    }

    private FilterBuilder(Operator op) {
        this();
        this.operator = op;
    }

    public static FilterBuilder newAnd() {
        return new FilterBuilder(OP_AND);
    }

    public static FilterBuilder newOr() {
        return new FilterBuilder(OP_OR);
    }

    public FilterBuilder add(String filter) {
        filter = filter?.trim();
        if(!String.isEmpty(filter)) {
            filters.add(filter);
        }
        return this;
    }
    public FilterBuilder add(FilterBuilder fb) {
        return add(fb.build());
    }

    public String build() {
        filters.remove('()');
        return filters.isEmpty() ? '' : '(' + String.join(new List<String>(filters), ' ' + operator + ' ') + ')';
    }

    public String build(Boolean withWhere) {
        String result = build();
        return withWhere && !String.isEmpty(result) ? ('WHERE ' + result) : result;
    }

}