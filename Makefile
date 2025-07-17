run:
	flutter run -d chrome

upgrade:
	flutter upgrade

upload-data:
	aws-sm s3 sync --delete './assets/data' s3://wheeloftime.silvermast.io/v2/data
	aws-sm cloudfront create-invalidation --distribution-id E1IQN1E4JD6ZW1 --paths "/v2/*" | tee

build-web:
	flutter build web

build-android:
	flutter build apk --release

build-ios:
	flutter build ipa --release && open -a Transporter `find build/ios/ipa -type f -name '*.ipa'`

generate-icons:
	dart run flutter_launcher_icons

# build-android:
# 	flutter build appbundle --release
# 	open build/app/outputs/bundle/release/

java-config:
	java -XshowSettings:properties -version