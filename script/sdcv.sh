#!/bin/sh

SDCV_DIR=~/.stardict/dic
mkdir -p $SDCV_DIR

# 牛津词典
# wget -c -P $SDCV_DIR http://download.huzheng.org/zh_CN/stardict-oxford-gb-formated-2.4.2.tar.bz2
wget -c -P $SDCV_DIR http://zedhugh.fun/stardict-oxford-gb-formated-2.4.2.tar.bz2

# 朗道英汉字典
# wget -c -P $SDCV_DIR http://download.huzheng.org/zh_CN/stardict-langdao-ec-gb-2.4.2.tar.bz2
wget -c -P $SDCV_DIR http://zedhugh.fun/stardict-langdao-ec-gb-2.4.2.tar.bz2

# 朗道汉英字典
# wget -c -P $SDCV_DIR http://download.huzheng.org/zh_CN/stardict-langdao-ce-gb-2.4.2.tar.bz2
wget -c -P $SDCV_DIR http://zedhugh.fun/stardict-langdao-ce-gb-2.4.2.tar.bz2

# cd $SDCV_DIR
find $SDCV_DIR -iname "*.tar.bz2" | xargs -I '{}' tar xpvf '{}' -C $SDCV_DIR
