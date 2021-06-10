# sync rom
repo init --depth=1 --no-repo-verify -u https://github.com/LineageOS/android.git -b lineage-18.1 -g default,-device,-mips,-darwin,-notdefault
repo sync -c --no-clone-bundle --no-tags --optimized-fetch --prune --force-sync -j8

# Git device tree
git clone -b lineage-18.1 --single-branch https://github.com/LineageOS/android_device_xiaomi_whyred device/xiaomi/whyred
git clone -b lineage-18.1 --single-branch https://github.com/LineageOS/android_kernel_xiaomi_sdm660.git kernel/xiaomi/sdm660
git clone -b lineage-18.1 --single-branch https://github.com/LineageOS/android_device_xiaomi_sdm660-common.git device/xiaomi/sdm660-common
git clone -b lineage-18.1 --single-branch https://gitlab.com/the-muppets/proprietary_vendor_xiaomi vendor/xiaomi

# build rom
source build/envsetup.sh
lunch lineage_whyred-userdebug
export TZ=Asia/Ho_Chi_Minh
mka bacon -j$(nproc --all)

mkdir -p ~/.config/rclone

echo "$rclone_config" > ~/.config/rclone/rclone.conf

ls -lash

rclone copy out/target/product/$(grep unch $CIRRUS_WORKING_DIR/build_rom.sh -m 1 | cut -d ' ' -f 2 | cut -d _ -f 2 | cut -d - -f 1)/*.zip doraemon:$(grep unch $CIRRUS_WORKING_DIR/build_rom.sh -m 1 | cut -d ' ' -f 2 | cut -d _ -f 2 | cut -d - -f 1) -P
