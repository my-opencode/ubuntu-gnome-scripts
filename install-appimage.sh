#!/bin/bash
clear
echo ==================
echo Appimage installer
echo ------------------

help_message=$(cat << end_of_message

Arguments: path/to/file.appimage
Example: ./appimage-installer.sh ./Downloads/my-new-program.appimage


end_of_message
)
err_no_arg="Missing appimage file path argument."
err_ext="File is not an appimage."
err_file="Path does not point to a file."
err_perm="Need write access to the appimage file."
err_exists="Desktop file already exists."

die () {
    echo >&2 "$@"
    exit 1
}

[ "$#" -eq 1 ] || die "${help_message}"$'\n\n'"$err_no_arg"
echo $1	
[[ "$1" =~ \.[Aa]pp[iI]mage$ ]] || die "${help_message}"$'\n\n'"$err_ext"
[ -f $1 ] || die "${help_message}"$'\n\n'"$err_file"
[ -w $1 ] || die "${help_message}"$'\n\n'"$err_perm"
[ -x $1 ] || echo "Making appimage executable..." && sudo chmod +x $1

set -e

filename=$(echo "$1"|sed -r "s/.*\///")
appname=$(echo "$filename" | sed -r "s/\.[^.]*$//")
app_dir=$HOME/Applications
[ -d $app_dir ] || mdir $app_dir
staging_dir=./.temp-appimage-installer
dktp_dir=/usr/share/applications

echo "Staging..."

[ -d $staging_dir ] || mkdir $staging_dir
mv $1 $staging_dir
cd $staging_dir

echo "Extracting appimage contents..."
./$filename --appimage-extract

echo "Preparing icon and desktop files..."
iconname=$(cat squashfs-root/*.desktop | grep Icon | sed "s/^Icon=//")
echo "icon is $iconname"
mv squashfs-root/$iconname.png $app_dir/$appname.png
sed -i -e "s@Icon=$iconname@Icon=$app_dir/$appname.png@" squashfs-root/*.desktop
sed -i -e "s&Exec=.*&Exec=$app_dir/$filename %F&" squashfs-root/*.desktop
mv squashfs-root/*.desktop $app_dir/

echo "Moving appimage..."
cd ..
mv $staging_dir/$filename $app_dir/
rm -rf $staging_dir

echo "Installing desktop file in /usr/share/applications..."
[ ! -f $dktp_dir/$appname.desktop ] || die "$err_exists"
sudo mv $app_dir/*.desktop $dktp_dir/
echo Done
