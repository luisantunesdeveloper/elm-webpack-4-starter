# elm-webpack-4-starter

### About:
Template for writing apps with [Elm](http://elm-lang.org/):

* Dev server with live reloading, using HMR
* [Webpack dashboard](https://github.com/FormidableLabs/webpack-dashboard) to have more info about the dev-server
* Support assets
  * Images
  * CSS/SCSS
    * PostCSS with Autoprefixer
    * [PurifyCSS](https://github.com/purifycss/purifycss) to remove unused CSS
    * CSS minification
* Elm-mdl
* Bundling and minification for deployment with [compressed version of assets](https://github.com/webpack-contrib/compression-webpack-plugin) (gzip)
* App scaffold using Richard Feldman [RealWorld example app](https://github.com/rtfeldman/elm-spa-example) and this [template](https://github.com/simon-larsson/elm-spa-template).
* [Webpack bundle analyzer](https://github.com/webpack-contrib/webpack-bundle-analyzer) to visualize the outputted files


### Requirements:
- [Yarn](https://yarnpkg.com/lang/en/docs/install/)
- Node >= v6.11

### Install:

Clone this repo into a new project folder, e.g. `my-elm-project`:
```
git clone https://github.com/romariolopezc/elm-webpack-4-starter my-elm-project
cd my-elm-project
```

Re-initialize the project folder as your own repo:
```
rm -rf .git
git init
git add .
git commit -m 'initial commit'
```

Install all dependencies using the handy `reinstall` script:
```
yarn reinstall
```
*This does a clean (re)install of all npm and elm packages, plus a global elm install.*


### Serve locally:
```
yarn start
```
* Access app at `http://localhost:8080/`
* Get coding! The entry point file is `src/elm/Main.elm`
* Browser will refresh automatically on any file changes, including css.


### Build & bundle for prod:
```
yarn build
```

* Files are saved into the `/dist` folder
* To check it, open `dist/index.html`

### Contributing
- PR's welcome :)

### Notes
* This webpack template was heavily inspired in the Elm Community [elm-webpack-starter](https://github.com/romariolopezc/elm-webpack-4-starter).

### Changelog

**Ver 0.0.1**
* Initial commit
