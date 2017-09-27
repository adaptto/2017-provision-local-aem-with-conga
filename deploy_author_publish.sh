#!/bin/sh

# defaultconfig
sling_url_author="http://localhost:4502"
sling_url_publish="http://localhost:4503"
sling_user="admin"
sling_password="admin"
conga_node_author="aem-author"
conga_node_publish="aem-publish"

####

default_build()
{
    motd
    clean_install
    deploy_artifacts
}

#####

motd()
{
echo "********************************************************************"
echo ""
echo " Cleans and installs all modules"
echo " Uploads and installs application complete packages, config and sample content"
echo ""
echo " Destinations:"
echo " - $conga_node_author: $sling_url_author"
echo " - $conga_node_publish: $sling_url_publish"
echo ""
echo "********************************************************************"
}

####

clean_install()
{
echo ""
echo "*** Build artifacts ***"
echo ""

mvn clean install eclipse:eclipse

if [ "$?" -ne "0" ]; then
  error_exit "*** Build artifacts FAILED ***"
fi
}

#####

deploy_artifacts()
{

echo ""
echo "*** Deploy AEM packages (author)  ***"
echo ""

cd config-definition
mvn -B -Dsling.url=$sling_url_author \
   -Dsling.user=$sling_user -Dsling.password=$sling_password \
   -Dconga.nodeDirectory=target/configuration/development/$conga_node_author \
   conga-aem:package-install

if [ "$?" -ne "0" ]; then
  error_exit "*** Deploying AEM packages FAILED ***"
fi

cd ../

echo ""
echo "*** Deploy AEM packages (publish)  ***"
echo ""

cd config-definition
mvn -B -Dsling.url=$sling_url_publish \
   -Dsling.user=$sling_user -Dsling.password=$sling_password \
   -Dconga.nodeDirectory=target/configuration/development/$conga_node_publish \
   conga-aem:package-install

if [ "$?" -ne "0" ]; then
  error_exit "*** Deploying AEM packages FAILED ***"
fi

cd ../

}

#####

error_exit()
{
  echo ""
  echo "$1" 1>&2
  echo ""
  if [[ $0 == *":\\"* ]]; then
    read -n1 -r -p "Press ENTER key to continue..."
  fi
  exit 1
}

default_build

echo ""
echo "*** Build complete ***"
echo ""

if [[ $0 == *":\\"* ]]; then
  read -n1 -r -p "Press ENTER key to continue..."
fi
