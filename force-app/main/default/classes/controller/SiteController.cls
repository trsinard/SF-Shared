public without sharing class SiteController {

    @AuraEnabled
    public static Boolean isAuthenticated() {
        return !(String.isEmpty(UserInfo.getSessionId()) || Auth.CommunitiesUtil.isGuestUser());
    }

    @AuraEnabled
    public static Network getNetwork(String id) {
        id = String.isEmpty(id) ? Network.getNetworkId() : id;
        Network result = null;
        if (!String.isEmpty(id)) {
            result = [SELECT Id, Name, UrlPathPrefix FROM Network WHERE Id = :id];
        }

        return result;
    }

    @AuraEnabled
    public static string getNetworkBasePath(String networkPrefix){
        Network result = [SELECT Id, Name, UrlPathPrefix FROM Network WHERE UrlPathPrefix = :networkPrefix LIMIT 1];

        String url = Network.getLoginUrl(result.Id);

        url = url.replace('/s/login', '/s');
        return url;

    }

}