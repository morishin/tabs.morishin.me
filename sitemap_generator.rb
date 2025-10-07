#!/usr/bin/env ruby
# frozen_string_literal: true

require 'time'
require 'uri'
require 'open3'
require 'fileutils'

# サイトのベースURL
BASE_URL = 'https://tabs.morishin.me'

# gitから最終更新日を取得する関数
def get_last_modified(file_path)
  stdout, _stderr, status = Open3.capture3('git', '-C', 'source/tabs', 'log', '-1', '--format=%ad', '--date=iso', '--', file_path)

  if status.success? && !stdout.strip.empty?
    Time.parse(stdout.strip).strftime('%Y-%m-%dT%H:%M:%SZ')
  else
    # ファイルが見つからない場合は現在時刻を返す
    Time.now.strftime('%Y-%m-%dT%H:%M:%SZ')
  end
end

# サイトマップのXMLを生成
def generate_sitemap
  xml = <<~XML
    <?xml version="1.0" encoding="UTF-8"?>
    <urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
      <url>
        <loc>#{BASE_URL}/</loc>
        <lastmod>#{Time.now.strftime('%Y-%m-%dT%H:%M:%SZ')}</lastmod>
        <changefreq>weekly</changefreq>
        <priority>1.0</priority>
      </url>
  XML

  # タブファイルを探索
  Dir.glob('source/tabs/*/*.gp5').each do |file_path|
    # ファイル名からURLを生成
    title = File.basename(file_path, '.gp5')
    url_title = URI.encode_uri_component(title.downcase)
    url = "#{BASE_URL}/player/#{url_title}"

    # ファイルパスからGitの相対パスを取得（submodule内のパス）
    relative_path = file_path.sub('source/tabs/', '')

    # 最終更新日を取得
    lastmod = get_last_modified(relative_path)

    xml += <<~XML
      <url>
        <loc>#{url}</loc>
        <lastmod>#{lastmod}</lastmod>
        <changefreq>monthly</changefreq>
        <priority>0.8</priority>
      </url>
    XML
  end

  xml += "</urlset>"
  xml
end

# サイトマップをファイルに書き込み
def write_sitemap
  # 直接buildディレクトリに書き込む
  sitemap_path = 'build/sitemap.xml'
  sitemap_content = generate_sitemap

  # ディレクトリが存在しない場合は作成
  FileUtils.mkdir_p(File.dirname(sitemap_path))

  File.write(sitemap_path, sitemap_content)
end

# このファイルが直接実行された場合のみメイン処理を実行
if __FILE__ == $PROGRAM_NAME
  # コマンドライン実行時はカレントディレクトリに出力（テスト用）
  sitemap_path = 'sitemap.xml'
  sitemap_content = generate_sitemap
  FileUtils.mkdir_p(File.dirname(sitemap_path))
  File.write(sitemap_path, sitemap_content)
end
