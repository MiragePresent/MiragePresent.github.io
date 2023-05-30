function loadJoke(data) {
    fetch('https://api.chucknorris.io/jokes/random')
    .then(response => response.json())
    .then(response => { data.joke = { text: response.value }});
}
