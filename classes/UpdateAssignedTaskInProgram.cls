public with sharing class UpdateAssignedTaskInProgram {
    public UpdateAssignedTaskInProgram() {

    }

    public static void checkTasks(List<Tasks_in_Program__c> taskInProgram) {
        List<Id> p = new List<Id>();
        //List<Task__c> t = new List<Task>();

        for(Tasks_in_Program__c tp : taskInProgram) {
            p.add(tp.Program__c);
            //t.add(tp.Task__c);
        }

        List<Assigned_Programs__c> assignedPrograms = [SELECT Id, Program__c, Contact__c, Start_date_of_Program__c
                                                            FROM Assigned_Programs__c
                                                            WHERE Program__c IN :p];


        
        List<Employee_Task__c> listOfAssignedTask = new List<Employee_Task__c>();

        if(assignedPrograms != null) {
            for(Tasks_in_Program__c tp : taskInProgram) {
                for(Assigned_Programs__c aps : assignedPrograms) {
                    if(tp.Program__c == aps.Program__c) {

                        Employee_Task__c employeeTask = new Employee_Task__c(); 
    

                        employeeTask.Program__c = aps.Program__c;
                        employeeTask.Task__c =  tp.Task__c;
                        employeeTask.Contact__c = aps.Contact__c;
                        employeeTask.Assigned_Programs__c = aps.Id;
                        
                        employeeTask.Due_Date__c = (aps.Start_date_of_Program__c).addDays(Integer.valueOf(tp.Number_of_days_in_due__c));
                        listOfAssignedTask.add(employeeTask);
    
                    }
                }
            }
            listOfAssignedTask = DuplicatecheckerForTasks.checkTasks(listOfAssignedTask);
            insert listOfAssignedTask;
        }
        

    }
}
