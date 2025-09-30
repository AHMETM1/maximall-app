# This file is for easier editing.
# All updates to this file should be update to the script in Runner.xcworkspace
# > Product (on App Menus) > Scheme > Edit Scheme > Build > Pre-actions.

# Enable this below line for debugging.
# exec > ${PROJECT_DIR}/prebuild.log 2>&1

echo "Copying configs/GoogleService-Info.plist to ios/GoogleService-Info.plist..."
/bin/cp -Rf ${PROJECT_DIR}/../configs/GoogleService-Info.plist ${PROJECT_DIR}/GoogleService-Info.plist

echo "Copying configs/customized to project..."
/bin/cp -Rf ${PROJECT_DIR}/../configs/customized/ ${PROJECT_DIR}/../

if [ -e ${PROJECT_DIR}/../configs/env.properties ] && [ -e ${PROJECT_DIR}/../configs/env.props ]
then
    echo "================================================================="
    echo "Warning: env.properties is deprecated, please rename to env.props"
    echo "================================================================="
fi

if [ -e ${PROJECT_DIR}/../configs/env.properties ] &&! [ -e ${PROJECT_DIR}/../configs/env.props ]
then
    echo "================================================================="
    echo "⚠️  Warning: env.properties is deprecated and should not be used"
    echo "🪄️  env.properties has been renamed to env.props automatically"
    echo "================================================================="
    /bin/mv -f ${PROJECT_DIR}/../configs/env.properties ${PROJECT_DIR}/../configs/env.props
fi

if [ -e ${PROJECT_DIR}/../configs/env.props ]
then
    echo "Loading configs from configs/env.props..."
    echo "#include? \"${PROJECT_DIR}/../configs/env.props\"" > ${PROJECT_DIR}/Config.xcconfig
else
    echo "Loading configs from configs/env.properties..."
    echo "#include? \"${PROJECT_DIR}/../configs/env.properties\"" > ${PROJECT_DIR}/Config.xcconfig
fi

# Check if `branchTestMode` is set, if not, set it to true
branchTestMode=${branchTestMode:-true}
echo "Exporting branch.json..."
echo "{\"useTestInstance\": ${branchTestMode}}" > ${PROJECT_DIR}/branch.json