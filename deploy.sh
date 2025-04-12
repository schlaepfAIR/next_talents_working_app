#!/bin/bash

# Exit on first error
set -e

echo "🔧 Step 1: Building Flutter web..."
flutter build web

echo "✅ Flutter web build complete."

echo "🛠️ Step 2: Ensuring firebase.json config is correct..."
cat <<EOF > firebase.json
{
  "hosting": {
    "public": "build/web",
    "ignore": [
      "firebase.json",
      "**/.*",
      "**/node_modules/**"
    ],
    "rewrites": [
      {
        "source": "**",
        "destination": "/index.html"
      }
    ]
  }
}
EOF

echo "📦 Step 3: Deploying to Firebase..."
firebase deploy

echo "🚀 Deployed successfully! Check your app URL above."
