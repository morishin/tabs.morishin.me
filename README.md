# tabs.morishin.me
My guitar transcriptions archive on the web 🎸📝

Tab files 👉 https://github.com/morishin/TAB  
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
    python -m SimpleHTTPServer
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
