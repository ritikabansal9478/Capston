public with sharing class DuplicatecheckerForTasks {
    public DuplicatecheckerForTasks() {

    }

    public static List<Employee_Task__c> checkTasks(List<Employee_Task__c> employeeTask) {
        //Employee_Task__c newTask = new Employee_Task__c();

        set<Id> taskSet = new Set<Id>();
        set<Id> employeeSet = new Set<Id>();

        for(Employee_Task__c e : employeeTask) {
            taskSet.add(e.Task__c);
            employeeSet.add(e.Contact__c);
        }

        List<Employee_Task__c> queryAssignedTasks = [SELECT Task__c, Contact__c
                                                        FROM Employee_Task__c
                                                        WHERE Task__c IN :taskSet OR Contact__c IN :employeeSet];

        Set<Id> queriedTaskSet = new Set<Id>();
        Set<Id> queriedEmployeeSet = new Set<Id>();

        for(Employee_Task__c e : queryAssignedTasks) {
            queriedTaskSet.add(e.Task__c);
            queriedEmployeeSet.add(e.Contact__c);
        }

        List<Employee_Task__c> uniqueList = new List<Employee_Task__c>();
        for(Employee_Task__c et : employeeTask) {
            if(queriedTaskSet.contains(et.Task__c) && queriedEmployeeSet.contains(et.Contact__c)) {
                et.addError('This Task already Exists!');
            }
            else{
                uniqueList.add(et);
            }
        }
        return uniqueList;
    }
}
