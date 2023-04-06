public with sharing class ScheduledTaskGenerator implements Scheduable {

    public void execute(ScheduableContext SC) {

        List<Timesheet__c> TimesheetsNeedingTasks = new List<Timesheet__c>();
        TimesheetsNeedingTasks = [SELECT Id
                                    FROM Timesheet__c
                                    WHERE CreatedDate = :Date.today().addDays(-7)];

    
        List<Task> generatedTask = new List<Task>();
        for(Timesheet__c t : TimesheetsNeedingTasks) {
            Task newTask = new Task();
            newTask.WhatId =  t.Id;
        }


    }
}
