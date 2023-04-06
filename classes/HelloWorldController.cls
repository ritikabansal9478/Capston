public with sharing class HelloWorldController {
    private Timesheet__c timesheet;
    public HelloWorldController(ApexPages.StandardController stdController) {
        this.Timesheet = (Timesheet__c) stdController.getRecord();
    }

    public String getWelcome() {
        return 'Welcome to ' + Timesheet.Name + '! Your Project Manager is ' + timesheet.ProjectManager__c.Name;
    }
}
