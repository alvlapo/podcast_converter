#! /bin/bash

# Convert mp3 to CBR from vesti.net podcast
# and replace dowload url in original atom rss
#
# enrone@gmail.com 2013

RSS_URL='http://vestinet.podfm.ru/rss/rss.xml'
RSS_NAME='vestinet'
SITE_PATH='/home/dudochka/www/alex.xskernel.org'
HOST_URL='http://alex.xskernel.org'
LAST_FILES_COUNT=12

RSS_FILE=$SITE_PATH/$RSS_NAME.xml

if [[ -e $RSS_FILE ]]
then
  rm $RSS_FILE
fi

DNL_DIR=$SITE_PATH/$RSS_NAME

if ! [[ -d $DNL_DIR ]]
then
  mkdir $DNL_DIR
fi

TMP_FILE_LIST=/tmp/$RSS_NAME

if ! [[ -e $TMP_FILE_LIST ]]
then
  touch $TMP_FILE_LIST
fi

wget $RSS_URL -O $RSS_FILE

MP3_URL_LIST=`grep -Po "(http:\/\/.+\.mp3)" $RSS_FILE | head -n $LAST_FILES_COUNT`

for MP3_URL in $MP3_URL_LIST
do
  MD5_NAME=`echo $MP3_URL | md5sum | cut -f1 -d" "`.mp3
  MP3_NAME=`echo $MP3_URL | cut -d/ -f 6`

  MP3_FILE=$DNL_DIR/$MD5_NAME

  if ! [[ -e $MP3_FILE ]]
  then
    TMP_MP3_FILE=/tmp/$MP3_NAME

    wget $MP3_URL -O $TMP_MP3_FILE
    lame -S --preset cbr 192 $TMP_MP3_FILE $MP3_FILE

    rm -f "$TMP_MP3_FILE"
  fi

  echo $MP3_FILE >> $TMP_FILE_LIST  

  NEW_MP3_URL=$HOST_URL/$RSS_NAME/$MD5_NAME

  replace -s "$MP3_URL?stat=rss" "$NEW_MP3_URL" -- $RSS_FILE
done

for FILE in $DNL_DIR/*.mp3
do
  if ! grep -q "$FILE" $TMP_FILE_LIST; then 
    echo "Remove old mp3 file $FILE"
    rm -f "$FILE"
  fi
done

rm -f "$TMP_FILE_LIST"
