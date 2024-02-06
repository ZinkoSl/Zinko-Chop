window.addEventListener('message', function (event) {
    var item = event.data;
    if (item.clear == true) {
        $(".items").empty();
    }
    if (item.display == true) {
        $(".container").show();
    }
    if (item.display == false) {
        $(".container").fadeOut(100);
    }
});

document.addEventListener('DOMContentLoaded', function () {
    $(".container").hide();
});

function sellItem(item, price) {
    $.post('http://zinko_chop/sellItem', JSON.stringify({ item: item, price: price}));
}

window.addEventListener('message', function (event) {
    var data = event.data;

    if (data.price !== undefined) {
    $(".items").append(`
        <div class="item">
            <img src="image/`+data.item+`.png">
            <button onclick="sellItem('`+data.item+`', '`+data.price+`')" type="button">SELL</button>
            <div class="square">
                <p>`+data.itemLabel+`<p>
                <p>Price: `+data.price+`$<p>
            </div>
        </div>
    `);
    }
});


