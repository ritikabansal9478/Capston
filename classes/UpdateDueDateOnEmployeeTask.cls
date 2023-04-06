public with sharing class UpdateDueDateOnEmployeeTask {
    public UpdateDueDateOnEmployeeTask() {

    }

    public static void updateDueDates(List<Employee_Task__c> employeetasks) {

        employeetasks = DuplicatecheckerForTasks.checkTasks(employeetasks);


        List<Id> tasklist = new List<Id>();
        
        for(Employee_Task__c et : employeetasks) {
            if(et.Program__c == null) {
                tasklist.add(et.Task__c);
            }
            
        }

        
        if(tasklist.size() >0) {
            Map<Id,Task__c> mapOfTask = new Map<Id, Task__c>([SELECT Name, Number_of_days_to_complete_the_Task__c	
                                                                FROM Task__c
                                                                WHERE Id IN :tasklist]);



            List<Employee_Task__c> listOfAssignedTask = new List<Employee_Task__c>();


            for(Employee_Task__c empTask : employeetasks) {
            Decimal numberofDays = mapOfTask.get(empTask.Task__c).Number_of_days_to_complete_the_Task__c;

            empTask.Due_Date__c = empTask.Start_date__c.addDays(numberofDays.intValue());
            }
        }
       

    }

    
}
