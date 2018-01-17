#!/bin/bash


# helm install stable/sonarqube --set persistence.enabled=true,persistence.storageClass='',persistence.accessMode='ReadWriteOnce'
# kubectl exec mysonar2-sonarqube-570423248-8v6jx -- curl -D - -s -k -X POST -c /tmp/cook.txt -b /tmp/cook.txt -d login=admin -d password=admin http://localhost:9000/api/authentication/login
# kubectl exec mysonar2-sonarqube-570423248-8v6jx -- curl -D - -s -k -X POST -c /tmp/cook.txt -b /tmp/cook.txt -d login=admin -d name=vvv4 http://localhost:9000/api/user_tokens/generate

# curl -D - -s -k -X POST -c /tmp/cook.txt -b /tmp/cook.txt -d login=admin -d password=admin http://104.214.112.246:9000/api/authentication/login
# curl -D - -s -k -X POST -c /tmp/cook.txt -b /tmp/cook.txt -d login=admin -d name=vvv104 http://104.214.112.246:9000/api/
# cat cookies.txt | grep XSRF-TOKEN | awk '{print $7;}'

#  curl  -D - -s -k -X POST -c cookies.txt 'http://104.214.112.246:9000/api/authentication/login' --data 'password=admin&login=admin' --compressed
#  curl  -D - -s -k -X POST -b cookies.txt 'http://104.214.112.246:9000/api/user_tokens/generate' -H 'X-XSRF-TOKEN: 2ehiq3gblcolg2t14svr26bkp8' --data 'name=aaa101&login=admin' --compressed
# helm init --upgrade
# helm install stable/nginx-ingress
# az network public-ip list -o  tsv | grep "13.95.237.21"
# RG ... az network public-ip list -o  tsv | grep "13.95.237.21" | awk '{print $12}'         (name je 8)
# az network public-ip update --resource-group MC_AKS2_valdaaks2_westeurope --name kubernetes-a6bf7013afb8011e7a5750a58ac1f139 --dns-name valdaaks2 --query [dnsSettings.fqdn] -o tsv
# cat /proc/sys/kernel/random/uuid | cut -d '-' -f 1

#  curl 'http://104.214.112.246:9000/api/user_tokens/generate' -H 'Cookie: JWT-SESSION=eyJhbGciOiJIUzI1NiJ9.eyJqdGkiOiJBV0RfRmpZV3FXWUlfd1ZzTS1vNSIsInN1YiI6ImFkbWluIiwiaWF0IjoxNTE2MTA4MTMzLCJleHAiOjE1MTYzNjczMzMsImxhc3RSZWZyZXNoVGltZSI6MTUxNjEwODEzMzkxMCwieHNyZlRva2VuIjoia2Rlb2xodXM1MnIybDRnN3J1bWhoaWc4NHAifQ.vOvz-gjidAsQYExT0eAhg8oexj3gPzurp0QlClNnB_w; XSRF-TOKEN=kdeolhus52r2l4g7rumhhig84p' -H 'Origin: http://104.214.112.246:9000' -H 'X-XSRF-TOKEN: kdeolhus52r2l4g7rumhhig84p' -H 'Accept-Language: en-US,en;q=0.9' -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/62.0.3202.97 Safari/537.36 Vivaldi/1.94.1008.40' -H 'Content-Type: application/x-www-form-urlencoded' -H 'Accept: application/json' -H 'Referer: http://104.214.112.246:9000/account/security/' -H 'Accept-Encoding: gzip, deflate' -H 'Connection: keep-alive' --data 'name=vvv102&login=admin' --compressed


#####################################################################
# user defined parameters
LOCATION="westeurope"
LOCATIONPOSTGRES="westeurope"
RESOURCEGROUP=""
KUBERNETESNAME=""
ACRNAME=""
POSTGRESQLNAME=""
POSTGRESQLUSER="kubeadmin"
POSTGRESQLPASSWORD="KubE123...EbuK"
JENKINSPASSWORD="password123"

while [[ $# > 0 ]]
do
  key="$1"
  shift
  case $key in
    --location)
      LOCATION="$1"
      shift
      ;;
    --locationpostgres)
      LOCATIONPOSTGRES="$1"
      shift
      ;;
    --resource-group)
      RESOURCEGROUP="$1"
      shift
      ;;
    --kubernetes-name)
      KUBERNETESNAME="$1"
      shift
      ;;
    --acr-name)
      ACRNAME="$1"
      shift
      ;;
    --postgresql-name)
      POSTGRESQLNAME="$1"
      shift
      ;;
    --postgresql-user)
      POSTGRESQLUSER="$1"
      shift
      ;;
    --postgresql-password)
      POSTGRESQLPASSWORD="$1"
      shift
      ;;
    --jenkins-password)
      JENKINSPASSWORD="$1"
      shift
      ;;
    *)
      echo "ERROR: Unknown argument '$key' to script '$0'" 1>&2
      exit -1
  esac
done


function throw_if_empty() {
  local name="$1"
  local value="$2"
  if [ -z "$value" ]; then
    echo "Parameter '$name' cannot be empty." 1>&2
    exit -1
  fi
}

#check parametrs
throw_if_empty --location $LOCATION
throw_if_empty --locationpostgres $LOCATIONPOSTGRES
throw_if_empty --resource-group $RESOURCEGROUP
throw_if_empty --kubernetes-name  $KUBERNETESNAME
throw_if_empty --acr-name  $ACRNAME
throw_if_empty --postgresql-name $POSTGRESQLNAME
throw_if_empty --postgresql-user $POSTGRESQLUSER
throw_if_empty --postgresql-password $POSTGRESQLPASSWORD
throw_if_empty --jenkins-password $JENKINSPASSWORD

#####################################################################
# constants
MYUUID = $(cat /proc/sys/kernel/random/uuid | cut -d '-' -f 1)
APPINSIGHTSNAME="${KUBERNETESNAME}-${MYUUID}"
APPDNSNAME="${KUBERNETESNAME}-${MYUUID}"
GITURL_SPA=""
GITBRANCH_SPA="master"
JENKINSJOBNAME_SPA="01-SPA"
HELMRELEASE_SPA="myreleasespa"
GITURL_TODO=""
GITBRANCH_TODO="master"
JENKINSJOBNAME_TODO="02-TODO"
HELMRELEASE_TODO="myreleasetodo"
GITURL_LIKE=""
GITBRANCH_LIKE="master"
JENKINSJOBNAME_LIKE="03-LIKE"
HELMRELEASE_LIKE="myreleaselike"
JENKINSSERVICENAME="myjenkins"
SONARSERVICENAME="mysonar"
SSHPUBKEY=~/.ssh/id_rsa.pub
KUBERNETESADMINUSER=$(whoami)

#####################################################################
# internal variables
KUBE_JENKINS=""
JENKINS_USER="admin"
JENKINS_KEY=""
REGISTRY_SERVER=""
REGISTRY_USER_NAME=""
REGISTRY_PASSWORD=""
CREDENTIALS_ID=""
CREDENTIALS_DESC=""
POSTGRESQLSERVER_URL="jdbc:postgresql://{postgresqlfqdn}:5432/postgres?user={postgresqluser}@{postgresqlname}&password={postgresqlpassword}&ssl=true"
APPINSIGHTS_KEY=""

#############################################################
# supporting functions
#############################################################
function retry_until_successful {
    counter=0
    echo "      .. EXEC:" "${@}"
    "${@}"
    while [ $? -ne 0 ]; do
        if [[ "$counter" -gt 50 ]]; then
            exit 1
        else
            let counter++
        fi
        echo "Retrying ..."
        sleep 5
        "${@}"
    done;
}

function run_cli_command {
    >&2 echo "      .. Running \"$1\"..."
    if [ -z "$2" ]; then
        retry_until_successful kubectl exec ${KUBE_JENKINS} -- java -jar  /var/jenkins_home/war/WEB-INF/jenkins-cli.jar -s http://localhost:8080 -auth "${JENKINS_USER}":"${JENKINS_KEY}" $1
    else
        retry_until_successful kubectl cp "$2" ${KUBE_JENKINS}:/tmp/tmp.xml
        tmpcmd="cat /tmp/tmp.xml | java -jar  /var/jenkins_home/war/WEB-INF/jenkins-cli.jar -s http://localhost:8080 -auth \"${JENKINS_USER}\":\"${JENKINS_KEY}\" $1"
        tmpcmd="${tmpcmd//'('/'\('}"
        tmpcmd="${tmpcmd//')'/'\)'}"
        echo "${tmpcmd}" > mycmd
        retry_until_successful kubectl cp mycmd ${KUBE_JENKINS}:/tmp/mycmd
        retry_until_successful kubectl exec ${KUBE_JENKINS} -- sh /tmp/mycmd
        retry_until_successful kubectl exec ${KUBE_JENKINS} -- rm /tmp/mycmd
        retry_until_successful kubectl exec ${KUBE_JENKINS} -- rm /tmp/tmp.xml
        rm mycmd
    fi
}

#############################################################
# create AKS
#############################################################

### login to Azure
# az login

### create resource group
echo "  .. create Resource group"
az group create --name ${RESOURCEGROUP} --location ${LOCATION} > /dev/null

### create kubernetes cluster
echo "  .. create AKS with kubernetes"
az aks create --resource-group ${RESOURCEGROUP} --name ${KUBERNETESNAME} --location ${LOCATION} --node-count 2 --kubernetes-version 1.8.1 --admin-username ${KUBERNETESADMINUSER} --ssh-key-value ${SSHPUBKEY} > /dev/null
sleep 10

#############################################################
# configure kubectl, helm
#############################################################

echo "  .. configuring kubectl and helm"

echo "      .. get kubectl credentials"
### initialize .kube/config
az aks get-credentials --resource-group=${RESOURCEGROUP} --name=${KUBERNETESNAME} > /dev/null
retry_until_successful kubectl get nodes
sleep 20
retry_until_successful kubectl patch storageclass default -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}' > /dev/null

echo "      .. helm init"
### initialize helm
retry_until_successful helm init > /dev/null
retry_until_successful helm version

#############################################################
# helm install services
#############################################################

echo "  .. installing jenkins"

echo "      .. helming jenkins"
### install jenkins to kubernetes cluster
helm install --name ${JENKINSSERVICENAME} stable/jenkins --set "Master.AdminPassword=${JENKINSPASSWORD}" >/dev/null

echo "      .. helming sonarqube"
### install sonarqube to kubernetes cluster
helm install --name ${SONARSERVICENAME} stable/sonarqube >/dev/null

echo "      .. helming nginx-ingress"
### install nginx ingress to kubernetes cluster
helm install --name default-ingress stable/nginx-ingress >/dev/null

#############################################################
# create Databases
#############################################################

### create application insights
echo "  .. create App Insights"
APPINSIGHTS_KEY=$(az resource create -g ${RESOURCEGROUP} -n ${APPINSIGHTSNAME} --resource-type microsoft.insights/components --is-full-object --properties "{ \"location\": \"${LOCATION}\", \"kind\": \"web\",  \"properties\": { \"ApplicationId\": \"${APPINSIGHTSNAME}\"  }}" --query [properties.InstrumentationKey] -o tsv)

### create postgresql as a service
echo "  .. create postgresql PaaS database"
az postgres server create -l ${LOCATIONPOSTGRES} -g ${RESOURCEGROUP} -n ${POSTGRESQLNAME} -u ${POSTGRESQLUSER} -p "${POSTGRESQLPASSWORD}" --performance-tier Basic --compute-units 50 --ssl-enforcement Enabled --storage-size 51200 > /dev/null
az postgres server firewall-rule create -g ${RESOURCEGROUP} -s ${POSTGRESQLNAME} -n allowall --start-ip-address 0.0.0.0 --end-ip-address 255.255.255.255 > /dev/null
read postgresqlfqdn <<< $(az postgres server show -g ${RESOURCEGROUP} -n ${POSTGRESQLNAME} --query [fullyQualifiedDomainName] -o tsv)
POSTGRESQLSERVER_URL=${POSTGRESQLSERVER_URL//'{postgresqlfqdn}'/${postgresqlfqdn}}
POSTGRESQLSERVER_URL=${POSTGRESQLSERVER_URL//'{postgresqlname}'/${POSTGRESQLNAME}}
POSTGRESQLSERVER_URL=${POSTGRESQLSERVER_URL//'{postgresqluser}'/${POSTGRESQLUSER}}
POSTGRESQLSERVER_URL=${POSTGRESQLSERVER_URL//'{postgresqlpassword}'/${POSTGRESQLPASSWORD}}

### create ACR
echo "  .. create ACR"
az acr create -n ${ACRNAME} -g ${RESOURCEGROUP} --location ${LOCATION} --admin-enabled true --sku Basic > /dev/null
read REGISTRY_SERVER <<< $(az acr show -g ${RESOURCEGROUP} -n ${ACRNAME} --query [loginServer] -o tsv)
read REGISTRY_USER_NAME REGISTRY_PASSWORD <<< $(az acr credential show -g ${RESOURCEGROUP} -n ${ACRNAME} --query [username,passwords[0].value] -o tsv)
CREDENTIALS_ID=${REGISTRY_SERVER}
CREDENTIALS_DESC=${REGISTRY_SERVER}

#############################################################
# nginx-ingress installation / configuration
#############################################################

echo "  .. installing nginx-ingress"

echo "      .. waiting for service public IP"
echo -n "     ."
NGINX_IP=""
while [  -z "$NGINX_IP" ]; do
    echo -n "."
    sleep 3
    NGINX_IP=$(kubectl describe service default-ingress-nginx-ingress-controller | grep "LoadBalancer Ingress:" | awk '{print $3}')
done
echo ""

APPPUBIPRG=$(az network public-ip list -o  tsv | grep "${NGINX_IP}" | awk '{print $12}')
APPPUBIPNAME=$(az network public-ip list -o  tsv | grep "${NGINX_IP}" | awk '{print $8}')
APPFQDN=$(az network public-ip update --resource-group ${APPPUBLICIPRG} --name ${APPPUBLICIPNAME} --dns-name ${APPDNSNAME} --query [dnsSettings.fqdn] -o tsv)

#############################################################
# sonarqube installation / configuration
#############################################################

echo "  .. installing sonarqube"

echo "      .. waiting for service public IP"
echo -n "     ."
SONAR_IP=""
while [  -z "$SONAR_IP" ]; do
    echo -n "."
    sleep 3
    SONAR_IP=$(kubectl describe service ${SONARSERVICENAME}-sonarqube | grep "LoadBalancer Ingress:" | awk '{print $3}')
done
echo ""

echo "      .. generate Sonar KEY"
retry_until_successful curl  -D - -s -k -X POST -c cookies.txt "http://${SONAR_IP}:9000/api/authentication/login" --data 'password=admin&login=admin' --compressed
SONARXSRF=$(cat cookies.txt | grep XSRF-TOKEN | awk '{print $7;}')
SONARKEY=$(curl  -D - -s -k -X POST -b cookies.txt "http://${SONAR_IP}:9000/api/user_tokens/generate" -H "X-XSRF-TOKEN: ${SONARXSRF}"  --data 'name=jekins001&login=admin' --compressed | grep '{"login":"'|jq -r .token)
SONARURL="http://${SONARSERVICENAME}-sonarqube:9000"

#############################################################
# jenkins installation / configuration
#############################################################

echo "  .. installing jenkins"

echo "      .. waiting for pods"
### get node name
echo -n "         ."
KUBE_JENKINS=""
while [  -z "$KUBE_JENKINS" ]; do
    echo -n "."
    sleep 3
    KUBE_JENKINS=$(kubectl get pods | grep "\-jenkins\-" | grep "Running" | awk '{print $1;}')
    if [ -z "${KUBE_JENKINS}" ]; then
    	KUBE_JENKINS=$(kubectl get pods | grep "\-jenkins\-" | grep "CrashLoopBackOff" | awk '{print $1;}')
	if [ -n "${KUBE_JENKINS}" ]; then
	    helm del --purge ${JENKINSSERVICENAME}
	    sleep 10
            helm install --name ${JENKINSSERVICENAME} stable/jenkins --set "Master.AdminPassword=${JENKINSPASSWORD}" 
	fi
    	KUBE_JENKINS=""
    fi
done
echo ""

echo "      .. configuring jenkins"
### get jenkins token
JENKINS_KEY=""
echo -n "         .. get key "
while [  -z "$JENKINS_KEY" ]; do
    echo -n "."
    sleep 5
    retry_until_successful kubectl exec ${KUBE_JENKINS} -- curl -D - -s -k -X POST -c /tmp/cook.txt -b /tmp/cook.txt -d j_username=${JENKINS_USER} -d j_password=${JENKINSPASSWORD} http://localhost:8080/j_security_check &>/dev/null
    JENKINS_KEY=$(kubectl exec ${KUBE_JENKINS} -- curl -D - -s -k -c /tmp/cook.txt -b /tmp/cook.txt http://localhost:8080/me/configure | grep "apiToken" | sed -n 's/.*id=.apiToken.\(.*\)\/>.*/\1/p' | sed -n 's/.*value=\"\([[:xdigit:]^>]*\)\".*/\1/p' 2>/dev/null)
done
echo -n "${JENKINS_KEY}"
echo ""

### install jenkins plugins
run_cli_command "install-plugin pipeline-utility-steps -deploy"
run_cli_command "install-plugin http_request -restart"
sleep 30

### create secrets for ACR

credentials_xml=$(cat <<EOF
<com.cloudbees.plugins.credentials.impl.UsernamePasswordCredentialsImpl>
  <scope>GLOBAL</scope>
  <id>{insert-credentials-id}</id>
  <description>{insert-credentials-description}</description>
  <username>{insert-user-name}</username>
  <password>{insert-user-password}</password>
</com.cloudbees.plugins.credentials.impl.UsernamePasswordCredentialsImpl>
EOF
)

#add user/pwd
credentials_xml=${credentials_xml//'{insert-credentials-id}'/${CREDENTIALS_ID}}
credentials_xml=${credentials_xml//'{insert-credentials-description}'/${CREDENTIALS_DESC}}
credentials_xml=${credentials_xml//'{insert-user-name}'/${REGISTRY_USER_NAME}}
credentials_xml=${credentials_xml//'{insert-user-password}'/${REGISTRY_PASSWORD}}
echo "${credentials_xml}" > tmp.xml
run_cli_command 'create-credentials-by-xml SystemCredentialsProvider::SystemContextResolver::jenkins (global)' "tmp.xml"
rm tmp.xml

### importing jobs for todo and like

job_xml=$(cat <<EOF
<?xml version='1.0' encoding='UTF-8'?>
<flow-definition plugin="workflow-job@2.13">
  <actions/>
  <description></description>
  <keepDependencies>false</keepDependencies>
  <properties>
    <hudson.model.ParametersDefinitionProperty>
      <parameterDefinitions>
        <hudson.model.StringParameterDefinition>
          <name>acr</name>
          <description></description>
          <defaultValue>{acr}</defaultValue>
        </hudson.model.StringParameterDefinition>
        <hudson.model.StringParameterDefinition>
          <name>giturl</name>
          <description></description>
          <defaultValue>{giturl}</defaultValue>
        </hudson.model.StringParameterDefinition>
        <hudson.model.StringParameterDefinition>
          <name>gitbranch</name>
          <description></description>
          <defaultValue>{gitbranch}</defaultValue>
        </hudson.model.StringParameterDefinition>
        <hudson.model.StringParameterDefinition>
          <name>imagename</name>
          <description></description>
          <defaultValue>{imagename}</defaultValue>
        </hudson.model.StringParameterDefinition>
      </parameterDefinitions>
    </hudson.model.ParametersDefinitionProperty>
    <org.jenkinsci.plugins.workflow.job.properties.PipelineTriggersJobProperty>
      <triggers/>
    </org.jenkinsci.plugins.workflow.job.properties.PipelineTriggersJobProperty>
  </properties>
  <definition class="org.jenkinsci.plugins.workflow.cps.CpsScmFlowDefinition" plugin="workflow-cps@2.40">
    <scm class="hudson.plugins.git.GitSCM" plugin="git@3.4.0">
      <configVersion>2</configVersion>
      <userRemoteConfigs>
        <hudson.plugins.git.UserRemoteConfig>
          <url>{giturl}</url>
        </hudson.plugins.git.UserRemoteConfig>
      </userRemoteConfigs>
      <branches>
        <hudson.plugins.git.BranchSpec>
          <name>*/{gitbranch}</name>
        </hudson.plugins.git.BranchSpec>
      </branches>
      <doGenerateSubmoduleConfigurations>false</doGenerateSubmoduleConfigurations>
      <submoduleCfg class="list"/>
      <extensions/>
    </scm>
    <scriptPath>src/main/jenkins/Jenkinsfile</scriptPath>
    <lightweight>true</lightweight>
  </definition>
  <triggers/>
  <disabled>false</disabled>
</flow-definition>
EOF
)

job_xml=${job_xml//'{acr}'/${REGISTRY_SERVER}}
job_xml=${job_xml//'{giturl}'/${GITURL}}
job_xml=${job_xml//'{gitbranch}'/${GITBRANCH}}
job_xml=${job_xml//'{imagename}'/${IMAGENAME}}
echo "${job_xml}" > tmp.xml
run_cli_command "create-job ${JENKINSJOBNAME}" "tmp.xml"
rm tmp.xml

#############################################################
# configure kubernetes credentials
#############################################################

echo "  .. install kubernetes security assets"
### create secrets (which will be used by helm install later on)
kubectl create secret generic ${HELMRELEASE}-${HELMCHART} --from-literal=application-insights-ikey="${APPINSIGHTS_KEY}" --from-literal=postgresqlserver-url="${POSTGRESQLSERVER_URL}"

#############################################################
# wait for jenkins public IP
#############################################################

echo "  .. waiting for jenkins public IP"
echo -n "     ."
JENKINS_IP=""
while [  -z "$JENKINS_IP" ]; do
    echo -n "."
    sleep 3
    JENKINS_IP=$(kubectl describe service myjenkins-jenkins | grep "LoadBalancer Ingress:" | awk '{print $3}')
done
echo ""

echo "### DONE!"
echo "### now you can login to http://${JENKINS_IP}:8080 with username: ${JENKINS_USER} , password: ${JENKINSPASSWORD}"