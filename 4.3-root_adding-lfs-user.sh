#!/bin/bash
echo ""
echo "### ------------------------"
echo "###  ADDING THE LFS USER ###"
echo "###      CHAPTER 4.3     ###"
echo "### Adding the LFS User"
echo "### Must be run as \"root\""
echo "### ------------------------"

echo ""
echo "... Loading commun functions and variables"
if [ ! -f ./script-all_commun-functions.sh ]
then
  echo "!! Fatal Error 1: './script-all_commun-functions.sh' not found."
  exit 1
fi
source ./script-all_commun-functions.sh

if [ ! -f ./script-all_commun-variables.sh ]
then
  echo "!! Fatal Error 1: './script-all_commun-variables.sh' not found."
  exit 1
fi
source ./script-all_commun-variables.sh

echo ""
echo "... Validating the environment"
check_partitions
is_user root
if [ $( readlink -f /bin/sh ) != "/bin/bash" ]
then
  echo "!! Fatal Error 3: /bin/sh is not symlinked to /bin/bash"
  exit 3
fi

echo ""
echo "... Creating the lfs group"
groupadd $LFS_GROUPNAME

echo ""
echo "... Creating the lfs user and add to lfs group"
useradd -s /bin/bash -g $LFS_GROUPNAME -m -k /dev/null $LFS_USERNAME

echo ""
echo "... Adding a password to the lfs user"
echo "$LFS_USERNAME:$LFS_PASSWORD" | chpasswd

echo ""
echo "... Granting to lfs user full access to $LFS_MOUNT/tools and LFS_MOUNT/sources"
chown -v lfs $LFS_MOUNT/tools
chown -v lfs $LFS_MOUNT/sources

echo ""
echo "... Copying all the lfs setup scripts that must be executed as lfs user to the lfs user's home directory"
mkdir /home/lfs/setup-scripts
cp 4.4* /home/lfs/setup-scripts
cp 5*.* /home/lfs/setup-scripts
cp script-* /home/lfs/setup-scripts
chown -R lfs:lfs /home/lfs/setup-scripts
chmod -R 760 /home/lfs/setup-scripts/

echo ""
echo "######### END OF CHAPTER 4.3 ########"
echo "///// HUMAN REQUIRED \\\\\\\\\\\\\\\\\\\\"
echo "### Please run the next steps:"
echo "### su - lfs"
echo "### cd setup-scripts"
echo "### ./4.4-lfs_setting-up-environment.sh"
echo ""

exit 0