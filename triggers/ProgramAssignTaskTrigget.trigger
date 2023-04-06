trigger ProgramAssignTaskTrigget on Assigned_Programs__c (before insert, after insert, before delete) {
    if(Trigger.isBefore && Trigger.isInsert) {
        DuplicateProgramChecker.checkPrograms(Trigger.new);
    }
    else if(Trigger.isAfter && Trigger.isInsert) {
        AssignAllTasksRelatedToProgram.assignAllTasks(Trigger.new);
    }
    else if(Trigger.isBefore && Trigger.isDelete) {
        DeleteAllTasksRelatedToProgram.deleteAssignedEmployeeTask(Trigger.oldMap);
    }
}

