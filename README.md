adaptTo() 2017 - Lightning Talk: Provision local AEM instance with CONGA
========================================================================

Code samples for lightning talk at adaptTo() 2017 in Berlin:<br/>
https://adapt.to/2017/en/schedule/lightning-talks.html


Requirements
------------

* Java 8
* Maven 3.3.9
* AEM 6.3 running on port 4502


Try it out
----------

* Deploy the sample application to your local AEM instance using the script `clean_install_deploy_package.sh`
  * This does a full `mvn clean install` and then uploads the content packages from `content-packages`
* Open the sample site at http://localhost:4502/editor.html/content/adaptto-fsresource-sample/en.html


Deploy Bundle
-------------

To deploy the OSGi bundle including the Sling Initial Content to the local AEM instance:

* Go to `bundles/core` and execute
```
mvn install sling:install
```
