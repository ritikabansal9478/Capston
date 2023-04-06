public with sharing class ProjectDuplicateCheckerFlow {

        @InvocableMethod
        public static List<Program__c> checkForDuplicateProjects (List<Program__c> insertedProjects) {
            System.debug('Called Dupe checker');
            return insertedProjects;
    }
}
