trigger EmployeeTaskTrigger on Employee_Task__c (before insert) {
    if(Trigger.isBefore && Trigger.isInsert) {
        UpdateDueDateOnEmployeeTask.updateDueDates(Trigger.New);    }
    
    
}