public with sharing class DeleteAllTasksRelatedToProgram {
    public DeleteAllTasksRelatedToProgram() {

    }

    public static void deleteAssignedEmployeeTask(Map<Id, Assigned_Programs__c> assignedPrograms) {
    
        List<Employee_Task__c> listofEmp =[SELECT Id
                                            FROM Employee_Task__c
                                            WHERE  Assigned_Programs__c IN :assignedPrograms.keySet()];


        delete listofEmp;

    }
}