.PHONY: docs push_cocoapods push_github check-podspec check-carthage check

# Create documentation
docs:
	jazzy -c
	rsync -ahvL --delete "assets" "docs"
	rm -r build

# Push spec to CocoaPods
push_cocoapods:
	bundle exec pod trunk push AutoMate-AppBuddy.podspec

# Push master, develop and tags to GitHub
push_github:
	git push github develop
	git push github master
	git push github --tags

# Check CocoaPod
check-podspec:
	bundle exec pod lib lint

# Check Carthage
check-carthage:
	carthage build --no-skip-current

# Check CocoaPod and Carthage
check: check-podspec check-carthage
