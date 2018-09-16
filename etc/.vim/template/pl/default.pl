#!/usr/local/bin/perl5.8

use strict;
use warnings;
use utf8;		# このスクリプトがUTF-8で書かれていることを示す

binmode(STDIN,  ":utf8");	# STDINから読み込む文字列はUTF-8であると仮定する
binmode(STDOUT, ":utf8");	# UTF-8に変換してSTDOUTへ書き込むようにする
binmode(STDERR, ":utf8");	# UTF-8に変換してSTDERRへ書き込むようにする

use File::Find;
use File::Basename;
use File::Path;
use File::stat;
