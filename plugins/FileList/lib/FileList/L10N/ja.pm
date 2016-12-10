package FileList::L10N::ja;

use strict;
use base 'FileList::L10N::en_us';
use vars qw( %Lexicon );

## The following is the translation table.

%Lexicon = (
    'FileInfo' => '出力ファイル一覧',

    # list
    'ArchiveType'             => 'ファイルの種類',
    'description of FileList' => '各ブログの出力したファイルの一覧を表示します',
    'FilePath'                => 'ファイルの出力先',
    'Template Name'           => 'テンプレート名',
    'Entry Title'             => '記事タイトル',
    'Individual'              => 'ブログ記事',
    'Category'                => 'カテゴリーアーカイブ',
    'Monthly'                 => '月別アーカイブ',
    'Yearly'                  => '年別アーカイブ',
    'Daily'                   => '日別アーカイブ',
    'index'                   => 'ブログインデックス',
    'Page'                    => 'ウェブページ',
    'Dynamic Publishing'      => '(ダイナミックパブリッシング)'
);
1;
