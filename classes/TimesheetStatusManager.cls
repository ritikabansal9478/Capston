public with sharing class TimesheetStatusManager {
    public TimesheetStatusManager() {

    }

    public static void updateRejectionCount(List<Timesheet__c> updatedTimesheets,
                                                Map<Id,Timesheet__c> oldTimesheetValues) {
        for(Timesheet__c t : updatedTimesheets) {
            if(t.status__c == 'Denied'
                && oldTimesheetValues.get(t.Id).status__c != 'Denied') {
                    if(t.Rejected_Count__c == null){
                        t.Rejected_Count__c = 0;
                    }
                t.Rejected_Count__c	 = t.Rejected_Count__c	+ 1;
            }
        }
    }

    public static void updateManager(List<Timesheet__c> updatedTimesheets) {
                                            
                                            for(Timesheet__c t : updatedTimesheets) {
                                               Program__c p = [SELECT Manager__c FROM Program__c WHERE Id =  :t.Program__c ];
                                                System.debug(p);
                                                t.ProjectManager__c	= p.Manager__c ;
                                            }                               
                                        
                                        
                                        
                                        
                                        
                                       }
                                       
                                       
    public static void closeRelatedTasks(List<Timesheet__c> updatedTimesheets) {
        List<Id> finalizedTimesheetIds = new List<Id>();
        for(Timesheet__c t: updatedTimesheets) {
            if(t.status__c == 'Submitted') {
                finalizedTimesheetIds.add(t.Id);
            }
        }

        List<Task> relatedTasks = [SELECT status
                                    FROM Task
                                    WHERE WhatId IN :finalizedTimesheetIds];

        
        for(Task t: relatedTasks) {
            t.Status ='Completed';
        }

        update relatedTasks;
    }
}