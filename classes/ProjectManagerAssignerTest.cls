@isTest

private class ProjectManagerAssignerTest {
    
    @isTest
    static void assignTimesheetManagerFromProgram_givenNewTimesheet_shouldAssignProjectManager() {
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        Contact testProgramManager = new Contact();
        testProgramManager.AccountId = testAccount.Id;
        testProgramManager.LastName = 'Doe';
        insert testProgramManager;

        Program__c testProgram = new Program__c();
        testProgram.Name = 'Test Program';
        testProgram.Manager__c = testProgramManager.Id;
        insert testProgram;


        Test.startTest();

        Timesheet__c testTimesheet = new Timesheet__c();
        testTimesheet.Program__c = testProgram.Id;
        insert testTimesheet;

        Test.stopTest();

        List<Timesheet__c> insertedTimesheets = [SELECT ProjectManager__c
                                                    FROM Timesheet__c];

        System.assertEquals(testProgram.Manager__c, 
                            insertedTimesheets[0].ProjectManager__c,
                            'The Program Manager field should be the same as on the Program');


    }
}
