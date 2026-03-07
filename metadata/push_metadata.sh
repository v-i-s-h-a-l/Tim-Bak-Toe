#!/usr/bin/env bash
#
# push_metadata.sh — Push App Store metadata via the App Store Connect API
#
# Usage:
#   ./push_metadata.sh \
#     --key-id YOUR_KEY_ID \
#     --issuer-id YOUR_ISSUER_ID \
#     --key-file /path/to/AuthKey_XXXXXX.p8
#
# Dependencies: openssl, curl, jq (brew install jq)
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
METADATA_FILE="$SCRIPT_DIR/metadata.json"
API_BASE="https://api.appstoreconnect.apple.com/v1"

# ── Parse arguments ──────────────────────────────────────────────────────────
KEY_ID=""
ISSUER_ID=""
KEY_FILE=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --key-id)    KEY_ID="$2";    shift 2 ;;
    --issuer-id) ISSUER_ID="$2"; shift 2 ;;
    --key-file)  KEY_FILE="$2";  shift 2 ;;
    *) echo "Unknown option: $1"; exit 1 ;;
  esac
done

if [[ -z "$KEY_ID" || -z "$ISSUER_ID" || -z "$KEY_FILE" ]]; then
  echo "Error: --key-id, --issuer-id, and --key-file are all required."
  exit 1
fi

if [[ ! -f "$KEY_FILE" ]]; then
  echo "Error: Key file not found: $KEY_FILE"
  exit 1
fi

# ── Generate JWT (using Python for correct ES256 R||S signature) ─────────────
TOKEN=$(python3 -c "
import jwt, time
with open('$KEY_FILE', 'r') as f:
    key = f.read()
now = int(time.time())
payload = {'iss': '$ISSUER_ID', 'iat': now, 'exp': now + 1200, 'aud': 'appstoreconnect-v1'}
print(jwt.encode(payload, key, algorithm='ES256', headers={'kid': '$KEY_ID'}))
")

api() {
  local method="$1" url="$2"
  shift 2
  curl -sg -X "$method" "$url" \
    -H "Authorization: Bearer $TOKEN" \
    -H "Content-Type: application/json" \
    "$@"
}

# ── Read metadata ────────────────────────────────────────────────────────────
BUNDLE_ID=$(jq -r '.app.bundleId' "$METADATA_FILE")
LOCALE=$(jq -r '.locale' "$METADATA_FILE")
PRIMARY_CAT=$(jq -r '.app.primaryCategory' "$METADATA_FILE")
PRIMARY_SUB1=$(jq -r '.app.primarySubcategoryOne // empty' "$METADATA_FILE")
PRIMARY_SUB2=$(jq -r '.app.primarySubcategoryTwo // empty' "$METADATA_FILE")
SECONDARY_CAT=$(jq -r '.app.secondaryCategory' "$METADATA_FILE")

echo "==> Looking up app with bundle ID: $BUNDLE_ID"

# ── Find the app ─────────────────────────────────────────────────────────────
APP_RESPONSE=$(api GET "$API_BASE/apps?filter[bundleId]=$BUNDLE_ID&include=appInfos,appStoreVersions")
APP_ID=$(echo "$APP_RESPONSE" | jq -r '.data[0].id // empty')

if [[ -z "$APP_ID" ]]; then
  echo "Error: App not found for bundle ID: $BUNDLE_ID"
  echo "Response: $APP_RESPONSE"
  exit 1
fi

echo "==> Found app: $APP_ID"

# ── Get appInfo ID ───────────────────────────────────────────────────────────
APP_INFO_ID=$(echo "$APP_RESPONSE" | jq -r '[.included[] | select(.type == "appInfos")][0].id // empty')

if [[ -z "$APP_INFO_ID" ]]; then
  echo "Error: Could not find appInfo. Fetching directly..."
  APP_INFO_RESPONSE=$(api GET "$API_BASE/apps/$APP_ID/appInfos")
  APP_INFO_ID=$(echo "$APP_INFO_RESPONSE" | jq -r '.data[0].id // empty')
fi

echo "==> App Info ID: $APP_INFO_ID"

# ── Update categories ────────────────────────────────────────────────────────
echo "==> Updating categories: $PRIMARY_CAT ($PRIMARY_SUB1, $PRIMARY_SUB2) / $SECONDARY_CAT"

CAT_BODY=$(jq -n \
  --arg id "$APP_INFO_ID" \
  --arg primary "$PRIMARY_CAT" \
  --arg sub1 "$PRIMARY_SUB1" \
  --arg sub2 "$PRIMARY_SUB2" \
  --arg secondary "$SECONDARY_CAT" \
  '{
    data: {
      type: "appInfos",
      id: $id,
      relationships: {
        primaryCategory: { data: { type: "appCategories", id: $primary } },
        primarySubcategoryOne: { data: (if $sub1 == "" then null else { type: "appCategories", id: $sub1 } end) },
        primarySubcategoryTwo: { data: (if $sub2 == "" then null else { type: "appCategories", id: $sub2 } end) },
        secondaryCategory: { data: { type: "appCategories", id: $secondary } },
        secondarySubcategoryOne: { data: null },
        secondarySubcategoryTwo: { data: null }
      }
    }
  }')
api PATCH "$API_BASE/appInfos/$APP_INFO_ID" -d "$CAT_BODY" | jq -r '.data.id // .errors'

# ── Update appInfoLocalization (name, subtitle) ─────────────────────────────
APP_NAME=$(jq -r '.appInfoLocalization.name' "$METADATA_FILE")
SUBTITLE=$(jq -r '.appInfoLocalization.subtitle' "$METADATA_FILE")
PRIVACY_URL=$(jq -r '.appInfoLocalization.privacyPolicyUrl' "$METADATA_FILE")

echo "==> Fetching appInfoLocalizations..."
LOCALIZATIONS=$(api GET "$API_BASE/appInfos/$APP_INFO_ID/appInfoLocalizations")
LOCALIZATION_ID=$(echo "$LOCALIZATIONS" | jq -r --arg loc "$LOCALE" '[.data[] | select(.attributes.locale == $loc)][0].id // empty')

if [[ -n "$LOCALIZATION_ID" ]]; then
  echo "==> Updating appInfoLocalization ($LOCALE): $LOCALIZATION_ID"
  api PATCH "$API_BASE/appInfoLocalizations/$LOCALIZATION_ID" -d "$(jq -n \
    --arg id "$LOCALIZATION_ID" \
    --arg name "$APP_NAME" \
    --arg subtitle "$SUBTITLE" \
    --arg privacy "$PRIVACY_URL" \
    '{
      data: {
        type: "appInfoLocalizations",
        id: $id,
        attributes: {
          name: $name,
          subtitle: $subtitle,
          privacyPolicyUrl: (if $privacy == "" then null else $privacy end)
        }
      }
    }')" | jq -r '.data.id // .errors'
else
  echo "==> Creating appInfoLocalization for $LOCALE"
  api POST "$API_BASE/appInfoLocalizations" -d "$(jq -n \
    --arg appInfoId "$APP_INFO_ID" \
    --arg locale "$LOCALE" \
    --arg name "$APP_NAME" \
    --arg subtitle "$SUBTITLE" \
    --arg privacy "$PRIVACY_URL" \
    '{
      data: {
        type: "appInfoLocalizations",
        attributes: {
          locale: $locale,
          name: $name,
          subtitle: $subtitle,
          privacyPolicyUrl: (if $privacy == "" then null else $privacy end)
        },
        relationships: {
          appInfo: {
            data: { type: "appInfos", id: $appInfoId }
          }
        }
      }
    }')" | jq -r '.data.id // .errors'
fi

# ── Find or identify the editable app store version ──────────────────────────
echo "==> Looking for editable App Store version..."
VERSION_ID=$(echo "$APP_RESPONSE" | jq -r '[.included[] | select(.type == "appStoreVersions" and .attributes.appStoreState != "READY_FOR_SALE" and .attributes.appStoreState != "PROCESSING_FOR_APP_STORE")][0].id // empty')

if [[ -z "$VERSION_ID" ]]; then
  VERSION_RESPONSE=$(api GET "$API_BASE/apps/$APP_ID/appStoreVersions?filter[appStoreState]=PREPARE_FOR_SUBMISSION,DEVELOPER_REJECTED,REJECTED,METADATA_REJECTED,WAITING_FOR_REVIEW,IN_REVIEW,INVALID_BINARY")
  VERSION_ID=$(echo "$VERSION_RESPONSE" | jq -r '.data[0].id // empty')
fi

if [[ -z "$VERSION_ID" ]]; then
  echo "Error: No editable App Store version found."
  echo "Create a new version in App Store Connect first, then re-run this script."
  exit 1
fi

echo "==> App Store Version ID: $VERSION_ID"

# ── Update versionLocalization (description, keywords, whatsNew, etc.) ───────
echo "==> Fetching version localizations..."
VER_LOCALIZATIONS=$(api GET "$API_BASE/appStoreVersions/$VERSION_ID/appStoreVersionLocalizations")
VER_LOC_ID=$(echo "$VER_LOCALIZATIONS" | jq -r --arg loc "$LOCALE" '[.data[] | select(.attributes.locale == $loc)][0].id // empty')

build_version_attributes() {
  jq -r '.versionLocalization' "$METADATA_FILE" | jq \
    '{
      description: .description,
      keywords: .keywords,
      promotionalText: .promotionalText,
      marketingUrl: (if .marketingUrl == "" then null else .marketingUrl end),
      supportUrl: (if .supportUrl == "" then null else .supportUrl end)
    }
    + (if .whatsNew != "" and .whatsNew != null then { whatsNew: .whatsNew } else {} end)'
}

if [[ -n "$VER_LOC_ID" ]]; then
  echo "==> Updating version localization ($LOCALE): $VER_LOC_ID"
  api PATCH "$API_BASE/appStoreVersionLocalizations/$VER_LOC_ID" -d "$(jq -n \
    --arg id "$VER_LOC_ID" \
    --argjson attrs "$(build_version_attributes)" \
    '{
      data: {
        type: "appStoreVersionLocalizations",
        id: $id,
        attributes: $attrs
      }
    }')" | jq -r '.data.id // .errors'
else
  echo "==> Creating version localization for $LOCALE"
  api POST "$API_BASE/appStoreVersionLocalizations" -d "$(jq -n \
    --arg verId "$VERSION_ID" \
    --arg locale "$LOCALE" \
    --argjson attrs "$(build_version_attributes)" \
    '{
      data: {
        type: "appStoreVersionLocalizations",
        attributes: ($attrs + { locale: $locale }),
        relationships: {
          appStoreVersion: {
            data: { type: "appStoreVersions", id: $verId }
          }
        }
      }
    }')" | jq -r '.data.id // .errors'
fi

echo ""
echo "==> Done! Metadata pushed to App Store Connect."
