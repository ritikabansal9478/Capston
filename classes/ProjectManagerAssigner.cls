public with sharing class ProjectManagerAssigner {
    public ProjectManagerAssigner() {

    }

    public static void assignTimesheetManagerFromProject(List<Timesheet__c> insertedTimesheet) {
        List<Id> projectIds = new List<Id>();

        for(Timesheet__c t: insertedTimesheet) {
            if(t.Program__c !=null) {
                //save the project manager
                projectIds.add(t.Program__c);    
            }  
        }

        List<Program__c> queriedProjects = [SELECT Id, 	Manager__c
                                                FROM Program__c
                                                WHERE Id IN :projectIds];
        


        Map<Id, Program__c> queriedProgramMap = new Map<Id, Program__c>();
        for(Program__c p : queriedProjects) {
            queriedProgramMap.put(p.Id, p);
        }

        for(Timesheet__c t : insertedTimesheet) {
            if(queriedProgramMap.containsKey(t.Program__c)){
                t.ProjectManager__c = queriedProgramMap.get(t.Program__c).Manager__c;
            }
            
        }
        //this is inefficient
        //for(Timesheet__c t :insertedTimesheet) {
          //  for(Program__c p :queriedProjects) {
            //    if(t.Program__c == p.Id) {

              //      t.ProjectManager__c = p.Manager__c;
                //}
           // }
        //}
    }
}

