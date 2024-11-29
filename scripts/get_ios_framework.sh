 #!/bin/bash
REPO='https://github.com/Tera-Group/One-Loyalty-Data-iOS'
TAG_VERSION='0.1.0'
XCFRAMEWORK_DIR="ios_xcframework"
ONE_LOYALTY_FRAMEWORK='oneloyalty.xcframework'

# create folder to load xcframework
rm -rf $XCFRAMEWORK_DIR
mkdir $XCFRAMEWORK_DIR

# load xcframework from tag/branch
git clone -b $TAG_VERSION --single-branch $REPO $XCFRAMEWORK_DIR
#git clone -b develop --single-branch $REPO $XCFRAMEWORK_DIR

# delete xcframework 
rm -rf ios/$ONE_LOYALTY_FRAMEWORK

# move xcframework
mv $XCFRAMEWORK_DIR/$ONE_LOYALTY_FRAMEWORK ios

# remove cache
rm -rf $XCFRAMEWORK_DIR