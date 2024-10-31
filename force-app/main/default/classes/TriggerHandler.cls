public abstract class TriggerHandler {

    private static final LoggingLevel LOGGING_LEVEL = LoggingLevel.FINE;

    private class TriggerState {
        @SuppressWarnings('ApexUnusedDeclaration')
        public final String instance_id = EncodingUtil.convertToHex(Crypto.generateAesKey(128)).substring(0, 32);
        @TestVisible Integer beforeInsertExecutions = 0;
        @TestVisible Integer beforeUpdateExecutions = 0;
        @TestVisible Integer afterInsertExecutions = 0;
        @TestVisible Integer afterUpdateExecutions = 0;
    }

    @TestVisible
    private static final Map<String, TriggerState> triggerStatesByImplementation = new Map<String, TriggerState>();

    @TestVisible
    private static Map<String, Map<Integer, String>> mockInsertRecordErrorByIndexByHandler = new Map<String, Map<Integer, String>>();

    @TestVisible
    private static void mockInsertError(String handler, Integer index, String message) {
        Map<Integer, String> entry = TriggerHandler.mockInsertRecordErrorByIndexByHandler.get(handler);
        entry = entry == null ? new Map<Integer, String>() : entry;
        entry.put(index, message);
        TriggerHandler.mockInsertRecordErrorByIndexByHandler.put(handler, entry);
    }
    @SuppressWarnings('ApexUnusedDeclaration') public virtual void onBeforeInsert(List<SObject> newRecords) {
        Map<Integer, String> mockInsertRecordErrorByIndex = mockInsertRecordErrorByIndexByHandler.get(getHandlerName());
        if (mockInsertRecordErrorByIndex != null) {
            for (Integer i : mockInsertRecordErrorByIndex.keySet()) {
                newRecords[i].addError(mockInsertRecordErrorByIndex.get(i));
            }
        }
    }
    @SuppressWarnings('ApexUnusedDeclaration') public virtual void onBeforeUpdate(List<SObject> oldRecords, List<SObject> newRecords, Map<Id, SObject> oldRecordMap, Map<Id, SObject> newRecordMap) {
    }
    @SuppressWarnings('ApexUnusedDeclaration') public virtual void onBeforeDelete(List<SObject> oldRecords, Map<Id, SObject> oldRecordMap) {
    }
    @SuppressWarnings('ApexUnusedDeclaration') public virtual void onAfterInsert(List<SObject> newRecords, Map<Id, SObject> newRecordMap) {
    }
    @SuppressWarnings('ApexUnusedDeclaration') public virtual void onAfterUpdate(List<SObject> oldRecords, List<SObject> newRecords, Map<Id, SObject> oldRecordMap, Map<Id, SObject> newRecordMap) {
    }
    @SuppressWarnings('ApexUnusedDeclaration') public virtual void onAfterDelete(List<SObject> oldRecords, Map<Id, SObject> oldRecordMap) {
    }
    @SuppressWarnings('ApexUnusedDeclaration') public virtual void onAfterUndelete(List<SObject> newRecords, Map<Id, SObject> newRecordMap) {
    }

    private Integer maxBeforeInsertExecutions = 2;
    private Integer maxBeforeUpdateExecutions = 2;
    private Integer maxAfterInsertExecutions = 2;
    private Integer maxAfterUpdateExecutions = 2;
    public TriggerHandler(Integer maxBeforeInsertExecutions, Integer maxBeforeUpdateExecutions, Integer maxAfterInsertExecutions, Integer maxAfterUpdateExecutions) {
        TriggerState triggerState = TriggerHandler.triggerStatesByImplementation.get(getHandlerName());
        if(triggerState == null) {
            triggerState = new TriggerState();
            TriggerHandler.triggerStatesByImplementation.put(getHandlerName(), triggerState);
            System.debug(LOGGING_LEVEL, 'Trigger Handler initialized for ' + getHandlerName() + ' with state instance: ' + getTriggerState().instance_id);
        } else {
            System.debug(LOGGING_LEVEL, 'Trigger Handler instance found for ' + getHandlerName() + ' with state instance: ' + getTriggerState().instance_id);
        }
        this.maxBeforeInsertExecutions = maxBeforeInsertExecutions;
        this.maxBeforeUpdateExecutions = maxBeforeUpdateExecutions;
        this.maxAfterInsertExecutions = maxAfterInsertExecutions;
        this.maxAfterUpdateExecutions = maxAfterUpdateExecutions;
    }
    public TriggerHandler() {
        this(2, 2, 2, 2);
    }
    public void execute() {
        if (Trigger.isBefore) {
            System.debug(LOGGING_LEVEL, 'Trigger starting BEFORE context for ' + getHandlerName() + ' with state: ' + JSON.serialize(getTriggerState()));
            if (Trigger.isInsert && getBeforeInsertExecutions() < this.maxBeforeInsertExecutions) {
                System.debug(LOGGING_LEVEL, getHandlerName() + ': Trigger executing BEFORE INSERT.');
                this.onBeforeInsert(Trigger.new);
                this.incrementBeforeInsertExecutions();
            } else if (Trigger.isUpdate && getBeforeUpdateExecutions() < this.maxBeforeUpdateExecutions) {
                System.debug(LOGGING_LEVEL, getHandlerName() + ': Trigger executing BEFORE UPDATE.');
                this.onBeforeUpdate(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap);
                this.incrementBeforeUpdateExecutions();
            } else if (Trigger.isDelete) {
                System.debug(LOGGING_LEVEL, getHandlerName() + ': Trigger executing BEFORE DELETE.');
                this.onBeforeDelete(Trigger.old, Trigger.oldMap);
            }
        }
        if (Trigger.isAfter) {
            System.debug(LOGGING_LEVEL, 'Trigger starting AFTER context for ' + getHandlerName() + ' with state: ' + JSON.serialize(getTriggerState()));
            if (Trigger.isInsert && getAfterInsertExecutions() < this.maxAfterInsertExecutions) {
                System.debug(LOGGING_LEVEL, getHandlerName() + ': Trigger executing AFTER INSERT.');
                this.onAfterInsert(Trigger.new, Trigger.newMap);
                this.incrementAfterInsertExecutions();
            } else if (Trigger.isUpdate && getAfterUpdateExecutions() < this.maxAfterUpdateExecutions) {
                System.debug(LOGGING_LEVEL, getHandlerName() + ': Trigger executing AFTER UPDATE.');
                this.onAfterUpdate(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap);
                this.incrementAfterUpdateExecutions();
            } else if (Trigger.isDelete) {
                System.debug(LOGGING_LEVEL, getHandlerName() + ': Trigger executing AFTER DELETE.');
                this.onAfterDelete(Trigger.old, Trigger.oldMap);
            } else if (Trigger.isUndelete) {
                System.debug(LOGGING_LEVEL, getHandlerName() + ': Trigger executing AFTER UNDELETE.');
                this.onAfterUndelete(Trigger.new, Trigger.newMap);
            }
        }
    }

    private String getHandlerName() {
        return String.valueOf(this).split(':')[0];
    }

    private TriggerState getTriggerState() {
        return TriggerHandler.triggerStatesByImplementation.get(getHandlerName());
    }
    public void incrementBeforeInsertExecutions() {
        TriggerState state = getTriggerState();
        state.beforeInsertExecutions++;
        TriggerHandler.triggerStatesByImplementation.put(getHandlerName(), state);
    }
    public void incrementBeforeUpdateExecutions() {
        TriggerState state = getTriggerState();
        state.beforeUpdateExecutions++;
        TriggerHandler.triggerStatesByImplementation.put(getHandlerName(), state);
    }
    public void incrementAfterInsertExecutions() {
        TriggerState state = getTriggerState();
        state.afterInsertExecutions++;
        TriggerHandler.triggerStatesByImplementation.put(getHandlerName(), state);
    }
    public void incrementAfterUpdateExecutions() {
        TriggerState state = getTriggerState();
        state.afterUpdateExecutions++;
        TriggerHandler.triggerStatesByImplementation.put(getHandlerName(), state);
    }
    public Integer getBeforeInsertExecutions() {
        return getTriggerState().beforeInsertExecutions;
    }
    public Integer getBeforeUpdateExecutions() {
        return getTriggerState().beforeUpdateExecutions;
    }
    public Integer getAfterInsertExecutions() {
        return getTriggerState().afterInsertExecutions;
    }
    public Integer getAfterUpdateExecutions() {
        return getTriggerState().afterUpdateExecutions;
    }

    public Boolean isChanged(SObject record, SObjectField fieldKey) {
        String recordId = record.Id;
        SObject oldEntry = recordId != null ? Trigger.oldMap?.get(recordId) : null;
        SObject newEntry = recordId != null ? Trigger.newMap?.get(recordId) : record;

        return newEntry?.get(fieldKey) != oldEntry?.get(fieldKey);
    }
}