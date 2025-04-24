# tabs.morishin.me
My guitar transcriptions archive on the web 🎸📝

Tab files 👉 https://github.com/morishin/TAB<br />
Tab viewer page uses 👉 https://github.com/CoderLine/alphaTab

## Develop
### Setup
```sh
git clone --recursive git@github.com:morishin/tabs.morishin.me.git
cd tabs.morishin.me
bundle install
```

### Run
1. Build pages

    ```sh
    bundle exec middleman build
    ```

1. Run server

    ```sh
    cd build
    python -m http.server
    ```

1. Open in browser

    ```sh
    open http://localhost:8000
    ```

### Add a tab file
1. Add a new tab file (`*.gp5`) to master branch of [morishin/TAB](https://github.com/morishin/TAB)

1. Update submodule

    ```sh
    cd tabs
    git pull origin master
    cd -
    ```

1. Rebuild pages

    ```sh
    bundle exec middleman build
    ```

### Sitemap
サイトマップは自動的にビルド時に生成されます。サイトマップは `source/sitemap.xml` として保存され、ビルド時に `build/sitemap.xml` にコピーされます。

手動でサイトマップを生成する場合は以下のコマンドを実行してください：

```sh
ruby sitemap_generator.rb
```

サイトマップには各タブファイル（`*.gp5`）の最終更新日が Git の履歴から取得され、`lastmod` として設定されます。
