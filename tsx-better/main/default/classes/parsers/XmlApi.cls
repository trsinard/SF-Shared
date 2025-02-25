
global with sharing class XmlApi {

    global static String convertXmlToJson(String xml) {
        return XmlUtil.convertXmlToJson(xml);
    }

    global static Map<String, Object> parse(String xml) {
        return XmlUtil.parse(xml);
    }
}