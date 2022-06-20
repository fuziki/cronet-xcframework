CRONET_VERSION=104.0.5112.8
RELEASE_VERSION=104.0.5112-8
CHANNEL=beta

GSUTIL=gsutil/gsutil
GSUTIL_DIR=tmp/gsutil
DL_DIR=tmp/dl
FAT_DIR=tmp/fat
DSYM_DIR=tmp/dsym
OUT_DIR=out

help-gsutil:
	${GSUTIL} help

help-create-xcframework:
	xcodebuild -create-xcframework -help

all: install-gsutil download fat-framework dsym xcframework zip checksum update-package release

install-gsutil:
	rm -rf tmp
	mkdir -p tmp
	mkdir -p ${GSUTIL_DIR}
	cd ${GSUTIL_DIR}; \
		curl -OL https://storage.googleapis.com/pub/gsutil.tar.gz -o gsutil.tar.gz
	tar xfz ${GSUTIL_DIR}/gsutil.tar.gz -C .

download:
	rm -rf ${DL_DIR}
	mkdir -p ${DL_DIR}
	${GSUTIL} -m cp -r \
		"gs://chromium-cronet/ios/${CRONET_VERSION}/Release-iphoneos" \
		"gs://chromium-cronet/ios/${CRONET_VERSION}/Release-iphonesimulator" \
		"gs://chromium-cronet/ios/${CRONET_VERSION}/Release-m1simulator" \
		${DL_DIR}

fat-framework:
	rm -rf ${FAT_DIR}
	mkdir -p ${FAT_DIR}/Cronet.framework
	cp -r ${DL_DIR}/Release-iphonesimulator/cronet/Cronet.framework ${FAT_DIR}
	lipo -create \
		${DL_DIR}/Release-iphonesimulator/cronet/Cronet.framework/Cronet \
		${DL_DIR}/Release-m1simulator/cronet/Cronet.framework/Cronet \
		-output ${FAT_DIR}/Cronet.framework/Cronet

dsym:
	rm -rf ${DSYM_DIR}
	mkdir -p ${DSYM_DIR}/Release-iphoneos
	mkdir -p ${DSYM_DIR}/Release-iphonesimulator
	mkdir -p ${DSYM_DIR}/Release-m1simulator
	mkdir -p ${DSYM_DIR}/arm64-x86-64
	tar xf ${DL_DIR}/Release-iphoneos/cronet/Cronet.dSYM.tar.bz2 \
		-C ${DSYM_DIR}/Release-iphoneos
	tar xf ${DL_DIR}/Release-iphonesimulator/cronet/Cronet.dSYM.tar.bz2 \
		-C ${DSYM_DIR}/Release-iphonesimulator
	tar xf ${DL_DIR}/Release-m1simulator/cronet/Cronet.dSYM.tar.bz2 \
		-C ${DSYM_DIR}/Release-m1simulator
	cp -r ${DSYM_DIR}/Release-iphonesimulator/Cronet.dSYM ${DSYM_DIR}/arm64-x86-64
	lipo -create \
		${DSYM_DIR}/Release-iphonesimulator/Cronet.dSYM/Contents/Resources/DWARF/Cronet \
		${DSYM_DIR}/Release-m1simulator/Cronet.dSYM/Contents/Resources/DWARF/Cronet \
		-output ${DSYM_DIR}/arm64-x86-64/Cronet.dSYM/Contents/Resources/DWARF/Cronet

xcframework:
	rm -rf ${OUT_DIR}
	mkdir -p ${OUT_DIR}
	xcodebuild -create-xcframework \
		-framework ${DL_DIR}/Release-iphoneos/cronet/Cronet.framework \
		-debug-symbols ${CURDIR}/${DSYM_DIR}/Release-iphoneos/Cronet.dSYM \
		-framework ${FAT_DIR}/Cronet.framework \
		-debug-symbols ${CURDIR}/${DSYM_DIR}/arm64-x86-64/Cronet.dSYM \
		-output ${OUT_DIR}/Cronet.xcframework
	cp ${DL_DIR}/Release-iphoneos/cronet/LICENSE ${OUT_DIR}/Cronet.xcframework

zip:
	cd ${OUT_DIR}; zip -r Cronet.xcframework.zip Cronet.xcframework

checksum:
	swift package compute-checksum out/Cronet.xcframework.zip

CHECKSUM = $(shell swift package compute-checksum out/Cronet.xcframework.zip)
update-package:
	echo ${CHECKSUM}
	sed \
		-e "s/VERSION/${RELEASE_VERSION}/" \
		-e "s/CHECKSUM/${CHECKSUM}/" \
		template/_Package.swift \
		> Package.swift
	git add Package.swift
	git commit -m "update Package.swift"
	git push origin HEAD

release:
	gh release create ${RELEASE_VERSION} \
		out/Cronet.xcframework.zip \
		--title "${RELEASE_VERSION}" \
		--notes "current_version: ${CRONET_VERSION}, channel: ${CHANNEL}"
