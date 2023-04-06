@isTest
private class TimesheetStatusMnagerTest {

    @isTest
    static void methodUnderTest_given_should() {

    }
    

    private static Program__c generateProgram(String programName) {
        Program__c testProgram = new Program__c();
        testProgram.Name = programName;
        return testProgram;
    }

    private static Timesheet__c generateTimesheet(Id programId, String status) {
        Timesheet__c testTimesheet = new Timesheet__c();
        testTimesheet.Program__c = programId;
        testTimesheet.Status__c = status;
        return testTimesheet;

    }


    @TestSetup
    static void createTimesheetData(){
        Program__c testProgram = generateProgram('Unit Test Program');
        insert testProgram;

        Timesheet__c testTimesheet = generateTimesheet(testProgram.Id, 'Draft');
        insert testTimesheet;
    }

    @isTest
    static void updateRejectionCount_givenRejectedTimesheet_shouldIncrement() {

        List<Timesheet__c> testTimesheets = [SELECT Status__c FROM Timesheet__c];

        Test.startTest();

        testTimesheets[0].Status__c = 'Denied';
        update testTimesheets[0];

        Test.stopTest();

        List<Timesheet__c> updatedTimesheets = [SELECT Rejected_Count__c FROM Timesheet__c];

        System.assertEquals(1, updatedTimesheets[0].Rejected_Count__c,
                                'Rejection number should have been incremented');


    }

    @isTest
    static void updateRejectionCount_givenSubmittedTimesheet_shouldNotIncrement() {
        List<Timesheet__c> testTimesheets = [SELECT Status__c FROM Timesheet__c];

        Test.startTest();

        testTimesheets[0].Status__c = 'Submitted';
        update testTimesheets[0];

        Test.stopTest();

        List<Timesheet__c> updatedTimesheets = [SELECT Rejected_Count__c FROM Timesheet__c];

        System.assertEquals(null, updatedTimesheets[0].Rejected_Count__c,
                                'Rejection number should not have been incremeneted');
                                

    }


    @isTest
    static void updateRejectionCount_givenAlreadyRejectedTimesheet_shouldNotIncrementAagain() {
        List<Timesheet__c> testTimesheets = [SELECT Status__c FROM Timesheet__c];

        testTimesheets[0].Status__c = 'Denied';
        update testTimesheets[0];

        Test.startTest();

        update testTimesheets[0];

        Test.stopTest();

        List<Timesheet__c> updatedTimesheets = [SELECT Rejected_Count__c FROM Timesheet__c];

        System.assertEquals(1, updatedTimesheets[0].Rejected_Count__c,
                                'Rejection number should not have been incremeneted more than once');
                                

    }
}
