#!/bin/sh

# ci_post_clone.sh
# Runs after Xcode Cloud clones the repository.
# Add any setup steps here (e.g., dependency installation, code generation).

echo "Post-clone script running..."

# Example: Install SwiftLint if needed
# brew install swiftlint

# Example: Install Swift packages if using SPM (Xcode Cloud does this automatically)
# xcodebuild -resolvePackageDependencies

echo "Post-clone script complete."
