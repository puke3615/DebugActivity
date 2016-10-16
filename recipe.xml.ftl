<?xml version="1.0"?>
<recipe>

    <instantiate from="root/src/app_package/DebugActivity.java.ftl"
                   to="${escapeXmlAttribute(srcOut)}/DebugActivity.java" />

    <instantiate from="root/src/app_package/SimpleActivity.java.ftl"
                   to="${escapeXmlAttribute(srcOut)}/${activityClass}.java" />

    <#if addJumpActivity>
    <instantiate from="root/src/app_package/JumpActivity.java.ftl"
                 to="${escapeXmlAttribute(srcOut)}/JumpActivity.java" />
    </#if>

    <merge from="root/AndroidManifest.xml.ftl"
           to="${escapeXmlAttribute(manifestOut)}/AndroidManifest.xml" />

    <open file="${escapeXmlAttribute(srcOut)}/${activityClass}.java" />
    <open file="${escapeXmlAttribute(srcOut)}/DebugActivity.java" />

</recipe>
