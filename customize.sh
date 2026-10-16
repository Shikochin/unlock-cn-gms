#!/system/bin/sh

FILES="\
/system/etc/permissions/services.cn.google.xml
/system/etc/permissions/com.oppo.features.cn_google.xml
/vendor/etc/permissions/services.cn.google.xml
/vendor/etc/permissions/cn.google.services.xml
/product/etc/permissions/services.cn.google.xml
/product/etc/permissions/cn.google.services.xml
/product/etc/sysconfig/cn_feature.xml
/odm/etc/permissions/com.gnss.bds_preference.xml
/my_bigball/etc/permissions/oplus_google_cn_gms_features.xml
/my_product/etc/permissions/oplus_google_cn_gms_features.xml
/my_heytap/etc/permissions/my_heytap_cn_gms_features.xml
/my_heytap/etc/permissions/my_heytap_cn_features.xml"

found=false

for origin in $FILES; do
    [ ! -e "$origin" ] && continue
    found=true

	case "$origin" in
		# Keep replacements in the module tree so the active metamodule mounts them.
		/system/*)
			target="$MODPATH$origin"
			;;
		*)
			target="$MODPATH/system$origin"
			;;
	esac

    mkdir -p "$(dirname "$target")"
    cp -f "$origin" "$target"
    sed -i '/cn.google.services/d' "$target"
    sed -i '/services_updater/d' "$target"
    ui_print "modify $origin"
done

$found || abort "No suitable permission file found!"
