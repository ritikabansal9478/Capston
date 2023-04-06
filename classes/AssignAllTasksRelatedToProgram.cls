public with sharing class AssignAllTasksRelatedToProgram {
    public AssignAllTasksRelatedToProgram() {

    }

    public static void assignAllTasks(List<Assigned_Programs__c> assignedPrograms) {
    
        List<Id> programIds = new List<Id>();

        for(Assigned_Programs__c a :assignedPrograms)
        {
            programIds.add(a.Program__c);
        }

        
        List<Tasks_in_Program__c> taskInProgramQuery = [SELECT Id, Program__c, Task__c, Number_of_days_in_due__c
                                                            FROM Tasks_in_Program__c
                                                            WHERE Program__c IN :programIds];
                                                            

        List<Employee_Task__c> listOfAssignedTask = new List<Employee_Task__c>();

        System.debug('assignedPrograms: ' + assignedPrograms);


        for(Assigned_Programs__c p : assignedPrograms) {
            for(Tasks_in_Program__c t : taskInProgramQuery) {
                if(p.Program__c == t.Program__c) {

                    Employee_Task__c employeeTask = new Employee_Task__c();
                    
                    employeeTask.Contact__c = p.Contact__c;
                    employeeTask.Task__c = t.Task__c;
                    employeeTask.Program__c = p.Program__c;
                    employeeTask.Assigned_Programs__c = p.Id;

                    employeeTask.Due_Date__c = (p.Start_date_of_Program__c).addDays(Integer.valueOf(t.Number_of_days_in_due__c));
                    listOfAssignedTask.add(employeeTask);
                }
            }
        }
        listOfAssignedTask = DuplicatecheckerForTasks.checkTasks(listOfAssignedTask);
        System.debug('listOfAssignedTask :' + listOfAssignedTask);
        insert listOfAssignedTask;        
    }
}
 