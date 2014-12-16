#!/bin/sh

set -o pipefail && xcodebuild test -workspace Example/VBTree.xcworkspace -scheme VBTree -sdk iphonesimulator ONLY_ACTIVE_ARCH=NO | xcpretty -c
