trigger EmployeeTrigger on Employee_Task__c (before insert) {
    if(Trigger.isBefore && Trigger.isInsert) {
        DuplicatecheckerForTasks.checkTasks(Trigger.new);
    }
}