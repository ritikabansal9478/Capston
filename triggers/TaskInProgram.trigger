trigger TaskInProgram on Tasks_in_Program__c (before insert, after insert) {
    if(Trigger.isAfter && Trigger.isInsert) {
        UpdateAssignedTaskInProgram.checkTasks(Trigger.new);
    }
    
}