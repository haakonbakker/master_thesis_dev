#!/bin/bash
xcodebuild -project  osa_tracker.xcodeproj/  -scheme cli -sdk iphoneos -configuration AppStoreDistribution archive -archivePath newestArchive
