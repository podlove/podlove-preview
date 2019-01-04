// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.scss"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative paths, for example:
// import socket from "./socket"


export var Player = {
    domNode: null,
    store: null,
    configure_by_jsonurl: function (url) {
        fetch(url)
            .then(res => res.json())
            .then((out) => {
                console.log('Checkout this JSON! ', out)
                // make sure we are paused
                this.store.dispatch({ "type": "UI_PAUSE", "payload": {} })

                // reinit
                this.store.dispatch({ type: 'INIT', payload: out })

                // to zero
                this.store.dispatch({ "type": "UPDATE_PLAYTIME", "payload": 0 })
            })
            .catch(err => { throw err });
    }
}

