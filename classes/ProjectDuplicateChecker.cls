public with sharing class ProjectDuplicateChecker {

    @InvocableMethod
    public static List<Program__c> checkForDuplicateProjects(List<Program__c> insertedPrograms) {
        System.debug('Called Dupe checker');

        List<Contact> newProgramManager = new List<Contact>();
        newProgramManager = [SELECT Id  
                                FROM Contact    
                                WHERE Name LIKE '%Dough'];

        if(newProgramManager.size() > 0) {
            for(Program__c p : insertedPrograms) {
                p.ProjectManager__c = newProgramManager[0].Id;
            }
        }

    
        return insertedPrograms;
    }
    
    
}
