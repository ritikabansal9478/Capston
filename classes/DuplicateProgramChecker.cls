public with sharing class DuplicateProgramChecker {
    public DuplicateProgramChecker() {

    }
    
        public static Boolean checkPrograms(List<Assigned_Programs__c> assignedPrograms) {
    
            Set<Id> programSet = new Set<Id>();
            Set<Id> employeeSet = new Set<Id>();
    
            for(Assigned_Programs__c a :assignedPrograms)
            {
                programSet.add(a.Program__c);
                employeeSet.add(a.Contact__c);
            }
            
            List<Assigned_Programs__c> queryAssignedProgram = [SELECT Program__c, Contact__c
                                                                    FROM Assigned_Programs__c
                                                                    WHERE Program__c IN :programSet OR Contact__c IN :employeeSet];
            
            Set<Id> queriedProgramSet = new Set<Id>();
            Set<Id> queriedEmployeeSet = new Set<Id>();
    
            for(Assigned_Programs__c a :queryAssignedProgram)
            {
                queriedProgramSet.add(a.Program__c);
                queriedEmployeeSet.add(a.Contact__c);
            }
    
            for(Assigned_Programs__c ap : assignedPrograms) {
                if(queriedProgramSet.contains(ap.Program__c) && queriedEmployeeSet.contains(ap.Contact__c)) {
                    ap.addError('This Program already Exists!');
                    return false;
                }
            }
            
            return true;
        }
    }
    
