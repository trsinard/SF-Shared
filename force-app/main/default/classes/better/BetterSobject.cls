public with sharing class BetterSobject {

    public static SObject removeField(SObject obj, String key) {
        Map<String, Object> asMap = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(obj));
        asMap.remove(key);
        return (SObject) JSON.deserialize(JSON.serialize(asMap), SObject.class);
    }

    public static SObject applyField(SObject obj, SObjectField valueField, Object value) {
        return applyField(obj, String.valueOf(valueField), value);
    }
    public static SObject applyField(SObject obj, String field, Object value) {
        if(obj != null && hasField(obj, field)) {
            obj.put(field, value);
        }
        return obj;
    }

    @TestVisible
    private static Map<SObjectType,  Map<String, SObjectField>> objectFieldCache = new Map<SObjectType,  Map<String, SObjectField>>();
    public static Object getField(SObject obj, SObjectField valueField) {
        return getField(obj, String.valueOf(valueField));
    }
    public static Object getField(SObject obj, String field) {
        Object result = null;
        if(obj != null && hasField(obj, field)) {
            result = obj.get(field);
        }
        return result;
    }

    public static Boolean hasField(SObject obj, String field) {
        return hasField(obj.getSObjectType(), field);
    }
    public static Boolean hasField(SObjectType objectType, String field) {
        if(!BetterSobject.objectFieldCache.containsKey(objectType)) {
            BetterSobject.objectFieldCache.put(objectType, objectType.getDescribe().fields.getMap());
        }
        Map<String, SObjectField> fieldsForObject = BetterSobject.objectFieldCache.get(objectType);
        return fieldsForObject.containsKey(field);
    }
}