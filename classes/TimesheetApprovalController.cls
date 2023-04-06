public with sharing class TimesheetApprovalController {

    @AuraEnabled
    public static List<Timesheet__c> getRelatedTimesheets(Id projectId){
        try {
            return [
                SELECT Id, Name, Status__c, Rejected_Count__c
                FROM Timesheet__c
                WHERE Program__c = :projectId
            ];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Timesheet__c createNewTimesheet(Id projectId) {
        try{
            Timesheet__c generateTimesheet = new Timesheet__c(Program__c = projectId);
            insert generateTimesheet;
            return generateTimesheet;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        
    }


    @AuraEnabled
    public static List<Timesheet__c> getRecentTimesheets(Id projectId) {
        try {
            return [
                SELECT Id, Name, Status__c, Rejected_Count__c
                FROM Timesheet__c
                WHERE Program__c = projectId
                AND CreatedDate = TODAY()
            ];
        } catch(Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}