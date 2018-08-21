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
Put a new tab file (`*.gp5`) in `tabs/` directory and rebuild.

```sh
bundle exec middleman build
```
