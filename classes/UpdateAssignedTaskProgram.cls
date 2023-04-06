public with sharing class UpdateAssignedTaskProgram {
    public UpdateAssignedTaskProgram() {

    }

    public static void checkTasks(List<Tasks_in_Program__c> taskInProgram) {
        List<Program__c> p = new List<Program__c>();
        List<Task__c> t = new List<Task>();

        for(Tasks_in_Program__c tp : taskInProgram) {
            p.add(tp.Program__c);
            t.add(tp.Task__c);
        }

        List<Tasks_in_Program__c> taskInProgramQuery = [SELECT Program__c, Task__c
                                                            FROM Tasks_in_Program__c
                                                            WHERE Program__c IN :p];

        List<Employee_Task__c> listOfAssignedTask = new List<Employee_Task__c>();

        for(Tasks_in_Program__c tp : taskInProgram) {
            for(Tasks_in_Program__c tIp : taskInProgramQuery) {
                if(tIp.Task__c != tp.Task__c) {
                    Tasks_in_Program__c taskProgram = new Tasks_in_Program__c();

                    taskInProgram.Task__c =  t.Task__c;

                    listOfAssignedTask.add(taskInProgram);

                }
            }
        }
        insert listOfAssignedTask;

    }
}
