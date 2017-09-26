#!/bin/sh

# defaultconfig
sling_url="http://localhost:4503"
sling_user="admin"
sling_password="admin"
sling_params=""
conga_node="aem-publish"

# set parameter variables before run
init()
{
sling_params="-Dsling.url=$sling_url -Dsling.user=$sling_user -Dsling.password=$sling_password"
}

####

# run modes
default_build()
{
    motd
    init
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
echo " Destination: $sling_url"
echo " CONGA Node:  $conga_node"
echo ""
echo "********************************************************************"
}

####

clean_install()
{
echo ""
echo "*** Build artifacts ***"
echo ""

mvn $sling_params -Pfast clean install eclipse:eclipse

if [ "$?" -ne "0" ]; then
  error_exit "*** Build artifacts FAILED ***"
fi
}

#####

deploy_artifacts()
{

echo ""
echo "*** Deploy AEM packages  ***"
echo ""

cd config-definition
mvn -B $sling_params -Dconga.nodeDirectory=target/configuration/development/$conga_node conga-aem:package-install

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
