source ${CICD_ROOT}/_common_deploy_logic.sh

# Caller can define any extra deploy arguments to be passed to bonfire
: ${EXTRA_DEPLOY_ARGS:=""}

# Caller can specify the type of pool to use
: ${NAMESPACE_POOL:="default"}

# Caller can alter the default dependency fetching method if desired
: ${OPTIONAL_DEPS_METHOD:="hybrid"}

# Whether or not to deploy frontends (default: false)
: ${DEPLOY_FRONTENDS:="false"}

# Deploy k8s resources for app and its dependencies (use insights-stage instead of insights-production for now)
# -> use this PR as the template ref when downloading configurations for this component
# -> use this PR's newly built image in the deployed configurations
set -x
export NAMESPACE=$(bonfire namespace reserve --pool ${NAMESPACE_POOL})
SMOKE_NAMESPACE=$NAMESPACE  # track which namespace was used here for 'teardown' in common_deploy_logic


bonfire deploy \
    ${APP_NAME} \
    --source=appsre \
    --ref-env ${REF_ENV} \
    --set-image-tag ${IMAGE}=${IMAGE_TAG} \
    --namespace ${NAMESPACE} \
    --timeout ${DEPLOY_TIMEOUT} \
    --optional-deps-method ${OPTIONAL_DEPS_METHOD} \
    --frontends ${DEPLOY_FRONTENDS} \
    ${TEMPLATE_REF_ARG} \
    ${COMPONENTS_ARG} \
    ${COMPONENTS_RESOURCES_ARG} \
    ${EXTRA_DEPLOY_ARGS}
set +x
