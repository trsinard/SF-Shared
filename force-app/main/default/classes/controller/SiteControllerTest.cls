@IsTest
public with sharing class SiteControllerTest {

    @TestSetup
    public static void setup() {
//        insert TestUser.createPatientPortalUser('Portal', 'User');
    }
    @IsTest
    public static void isAuthenticatedTrueWhenAuthenticated() {
        User testUser = [
            SELECT Id,
                Email
            FROM User
            WHERE FirstName = 'Portal'
            AND LastName = 'User'
        ];
        Boolean error = false;
        System.runAs(testUser) {
            System.assertEquals(true, SiteController.isAuthenticated());
        }
    }

    @IsTest
    public static void isAuthenticatedFalseWhenGuest() {
        User guestUser = [
            SELECT Id
            FROM User
            WHERE Profile.Name = 'Staff Scheduling Profile'
        ];

        System.runAs(guestUser) {
            System.assertEquals(false, SiteController.isAuthenticated());
        }
    }

    @IsTest
    public static void getsExpectedNetworkInformation() {

        Network network = [SELECT Id FROM Network WHERE UrlPathPrefix = 'patient'];
        Network result = SiteController.getNetwork(network.Id);
        System.assertEquals('patient', result.UrlPathPrefix);
    }

    @IsTest
    public static void getsNetworkBasePath() {
        Network patientNetwork = [SELECT Id, UrlPathPrefix FROM Network WHERE UrlPathPrefix = 'patient'];
        String expectedUrl = Network.getLoginUrl(patientNetwork.Id).substringBeforeLast('/login');
        String result = SiteController.getNetworkBasePath('patient');
        System.assertEquals(expectedUrl, result);
    }

}