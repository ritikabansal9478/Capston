public with sharing class TaskSelectorController {

    //this function is adding 
    @AuraEnabled(cacheable=true)
    public static List<Task__c> getRelatedTask(String inputString, Id programId){
        try {
            
            Program__c prog = [
                        SELECT Id, Audience_Type__c	
                        FROM Program__c
                        WHERE Id = :programId];

            List<Task__c> TrainingTasks = [
                    SELECT Id, Name, Number_of_days_to_complete_the_Task__c, Audience_Type__c	
                    FROM Task__c
                    WHERE Audience_Type__c	includes(:prog.Audience_Type__c)];

                    if(inputString == '') {
                        TrainingTasks = checkDuplicateTask(TrainingTasks, programId);
                        return TrainingTasks;
                    }
                    else {
                        String soqlInput = '%';
                soqlInput += inputString;
                soqlInput += '%';
                return [SELECT Id, Name, Number_of_days_to_complete_the_Task__c, Audience_Type__c
                        FROM Task__c
                        WHERE Name
                        LIKE :soqlInput
                        LIMIT 10];
                    }

            
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        } 
    }

    //trial method for search
    /*@AuraEnabled(cacheable=true)
    public static List<Task__c> getRelatedTask(String inputString, Id programId) {
        try{
            List<Tasks_in_Program__c> assignedTasks = new List<Tasks_in_Program__c>([SELECT Id, Task__c
                                                                                        FROM Tasks_in_Program__c
                                                                                        WHERE Tasks_in_Program__c.Program__c = :programId]);
            Set<Id> taskSet = new Set<Id>();
            for (Tasks_in_Program__c t : assignedTasks) {
                taskSet.add(t.Task__c);
            }
            if (inputString == '') {
                return [SELECT Id, Name, Audience_Type__c
                        FROM Task__c];
            } else {
                String soqlInput = '%';
                soqlInput += inputString;
                soqlInput += '%';
                return [SELECT Id, Name, Audience_Type__c
                        FROM Task__c
                        WHERE Name
                        LIKE :soqlInput
                        LIMIT 10];
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        } 
    }*/


    public static List<Task__c> checkDuplicateTask(List<Task__c> TrainingTasks, Id programId) {
        List<Tasks_in_Program__c> taskAssignments = [ SELECT Id, Task__c        
                                                        FROM Tasks_in_Program__c
                                                        WHERE Program__c = :programId];
        

        if(taskAssignments.size() >0) {
            List<Id> listOfTaskIds = new List<Id>();
            for(Tasks_in_Program__c taskProgram : taskAssignments) {
                listOfTaskIds.add(taskProgram.Task__c);
            }
            List<Task__c> uniqueTasks = new List<Task__c>();
            for(Task__c taskinProgr : TrainingTasks) {
                if(!listOfTaskIds.contains(taskinProgr.Id)) {
                    uniqueTasks.add(taskinProgr);
                }
            }
            return uniqueTasks;
        }
        return TrainingTasks;
    }
    
    @AuraEnabled
    public static List<Tasks_in_Program__c> assignSelectedTaskToProgram(List<Id> taskIn, Id programId ){
        try {

            List<Tasks_in_Program__c> taskInProgram = new List<Tasks_in_Program__c>();

            for(Id tlist : taskIn) {
                Tasks_in_Program__c taskInpro = new Tasks_in_Program__c();
                
                taskInpro.Program__c  = programId;
                taskInpro.Task__c = tlist;
                taskInpro.Number_of_days_in_due__c	= 7;
                taskInProgram.add(taskInpro);
            }
            insert taskInProgram;
            return taskInProgram;

        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }


    @AuraEnabled(cacheable=true)
    public static List<Task__c> searchTask(string searchKey) {
         searchKey = '%' + searchKey + '%';
		
       // create contact list to store search result 
        List<Task__c> taskListRecord = new List<Task__c>();
     
	   // query contact records
        for(Task__c queryTask : [Select Id,Name, Audience_Type__c
                                    From Task__c
                                    WHERE Name LIKE : searchKey]){
                    taskListRecord.add(queryTask);
        }
        
         if(taskListRecord.size() == 0){
            throw new AuraHandledException('No Record Found..'); 
         }
         
        return taskListRecord;
    }

    @AuraEnabled(cacheable = true)
    public static List<Assigned_Programs__c> fetchAssignedPrograms(Id givenProgram) {
        try {
            return [
                    SELECT Name, Program__c, Contact__c, Contact_Name__c, Status__c, Start_date_of_Program__c, Due_Date__c
                    FROM Assigned_Programs__c
                    WHERE Program__c = :givenProgram];
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }  
    }
    
    @AuraEnabled
    public static void deleteSelectedTasks(List<Assigned_Programs__c> assignedPrograms) {
        delete assignedPrograms;
    }

    @AuraEnabled
    public static void addNewTaskToProgram(Id taskId, Id givenProgram) {
        try {

            Tasks_in_Program__c newTaskInProgram = new Tasks_in_Program__c();

            newTaskInProgram.Program__c = givenProgram;
            newTaskInProgram.Task__c = taskId;
            Program__c programTask = [ SELECT Audience_Type__c
                                        FROM Program__c
                                        WHERE Id = :givenProgram
                                        
            ];

            Task__c existingTask = [ SELECT Audience_Type__c
                                        FROM Task__c
                                        WHERE Id = :taskId];

            if(programTask.Audience_Type__c == existingTask.Audience_Type__c) {
                insert newTaskInProgram;
            }
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

}
