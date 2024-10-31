public with sharing class BetterCollection {


    public static Object get(List<Object> collection, Integer index) {
        return collection != null && collection.size() > index && index >= 0 ? collection.get(index) : null;
    }

    public static List<Object> pluck(List<SObject> records, String key) {
        List<Object> results = new List<Object>();
        for (SObject record : records) {
            results.add(record.get(key));
        }
        return results;
    }

    public static List<Id> pluckId(List<SObject> records, String key) {
        List<Id> results = new List<Id>();
        for (SObject record : records) {
            results.add(BetterString.valueOf(record.get(key)));
        }
        return results;
    }

    public static List<Object> noNull(List<Object> collection) {
        return collection == null ? new List<Object>() : collection;
    }

    public static Boolean isEmpty(Object collection) {
        Boolean results = collection == null;
        if (!results) {
            try {
                String serialized = JSON.serialize(collection);
                List<Object> deserialized = (List<Object>) JSON.deserializeUntyped(serialized);
                results = deserialized == null || deserialized.isEmpty();
            } catch (System.TypeException e) {
                results = true;
            }
        }
        return results;
    }

    public static List<String> slice(List<String> objs, Integer startIndex, Integer endIndex) {
        startIndex = Math.max(0, startIndex);
        endIndex = Math.min(objs.size(), endIndex);
        List<String> newObjs = new List<String>();
        for (Integer i = startIndex; i < endIndex && i < objs.size(); i++) {
            newObjs.add(objs[i]);
        }
        return newObjs;
    }

     public static List<Object> slice(List<Object> objs, Integer startIndex, Integer endIndex) {
        startIndex = Math.max(0, startIndex);
        endIndex = Math.min(objs.size(), endIndex);
        List<Object> newObjs = new List<Object>();
        for (Integer i = startIndex; i < endIndex && i < objs.size(); i++) {
            newObjs.add(objs[i]);
        }
        return newObjs;
    }

    public static Object at(List<Object> lst, Integer index) {
        return lst != null && index < lst.size() && index >= 0 ? lst.get(index) : null;
    }
    public static Set<String> dedupeIgnoreCase(Set<String> entries) {
        Map<String, String> newValueToOriginalValue = new Map<String, String>();
        for (String entry : entries) {
            if (!newValueToOriginalValue.containsKey(entry.toUpperCase())) {
                newValueToOriginalValue.put(entry.toUpperCase(), entry);
            }
        }
        return new Set<String>(newValueToOriginalValue.values());
    }
}