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


const Player = {
    domNode: null,
    store: null,
    configure_by_jsonurl: function (url) {
        fetch(url)
            .then(res => res.json())
            .then((out) => {
                console.log('Checkout this JSON! ', out)
                // make sure we are paused
                this.store.dispatch({
                    "type": "UI_PAUSE",
                    "payload": {}
                })

                // reinit
                this.store.dispatch({
                    type: 'INIT',
                    payload: out
                })

                // to zero
                this.store.dispatch({
                    "type": "UPDATE_PLAYTIME",
                    "payload": 0
                })
            })
            .catch(err => {
                throw err
            });
    }
}

const init_player = function (id) {
    const player_wrapper = document.getElementById(id);
    const config = JSON.parse(player_wrapper.getAttribute("data-config"));

    podlovePlayer(player_wrapper, config).then(function (store) {
        Player.store = store
        Player.domNode = player_wrapper
    })
}

const init_clickables = function () {
    const clickables = document.getElementsByClassName("start-player-btn");

    for (let i = 0; i < clickables.length; i++) {
        const btn = clickables[i];
        const config_url = btn.getAttribute("data-config-url");

        btn.addEventListener("click", function (event) {
            Player.configure_by_jsonurl(config_url);
            Player.domNode.scrollIntoView();
            event.preventDefault();
        })
    }
}

document.addEventListener("DOMContentLoaded", function (_event) {
    init_player("player_wrapper");
    init_clickables();
});
