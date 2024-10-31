public with sharing class QueryBuilder {


    private final Set<String> fields;
    private String what;
    private String filter;
    private List<String> orderBy;
    private Integer theLimit;
    private QueryBuilder() {
        this.orderBy = new List<String>();
    }
    private QueryBuilder(Set<String> fields) {
        this();
        this.fields = fields;
    }
    public static QueryBuilder selectFrom(SObjectType objType) {
        QueryBuilder builder = new QueryBuilder(new Set<String>{'Id'});
        return builder.fromObject(objType);
    }

    public static QueryBuilder selectFields(Set<String> fields) {
        fields = fields == null ? new Set<String>() : fields;
        fields.add('Id');
        fields = BetterCollection.dedupeIgnoreCase(fields);
        return new QueryBuilder(fields);
    }

    public static QueryBuilder selectAllFrom(SObjectType objType) {
        return selectFields(objType.getDescribe().fields.getMap().keySet().clone()).fromObject(objType);
    }
    public static QueryBuilder selectFields(Set<SObjectField> fields) {
        Set<String> fieldStrings = new Set<String>();
        for(SObjectField field : fields) {
            if(field.getDescribe().isAccessible()) {
                fieldStrings.add(BetterString.valueOf(field));
            }
        }
        return QueryBuilder.selectFields(fieldStrings);
    }


    public QueryBuilder fromObject(String what) {
        this.what = what;
        return this;
    }

    public QueryBuilder fromObject(SObjectType objType) {
        return this.fromObject(BetterString.valueOf(objType));
    }

    public QueryBuilder filter(String filter) {
        this.filter = filter;
        return this;
    }

    public QueryBuilder filter(FilterBuilder filter) {
        this.filter = filter.build(false);
        return this;
    }

    public QueryBuilder orderBy(List<String> fields) {
        for(String field : fields) {
            orderBy(field, true);
        }
        return this;
    }
    public QueryBuilder orderBy(String field, Boolean isAsc) {
        return orderBy(field, isAsc, null);
    }

    public QueryBuilder orderBy(String field, Boolean isAsc, Boolean nullsLast) {
        if(field != null) {
            this.orderBy.add(field + ' ' + (isAsc == true ? 'ASC' : 'DESC') + (nullsLast == null ? '' : (nullsLast ? ' NULLS LAST' : ' NULLS FIRST')));
        }
        return this;
    }

    public QueryBuilder withLimit(Integer num) {
        num = num == null ? BetterInteger.MAX : num;
        this.theLimit = Math.max(0,Math.min(num, 50000));
        return this;
    }

    public String build() {
        if(String.isBlank(this.what)) {
            throw new QueryException('Missing object to query from.');
        }
        String root = 'SELECT ' + String.join(new List<String>(this.fields), ',') + ' FROM ' + this.what;
        String query = root + (!String.isEmpty(this.filter) ? ' WHERE ' + this.filter : '');
        query += !BetterCollection.isEmpty(this.orderBy) ? (' ORDER BY ' + String.join(this.orderBy, ',')) : '';
        query += this.theLimit != null ? (' LIMIT ' + this.theLimit) : '';
        return query;
    }

}