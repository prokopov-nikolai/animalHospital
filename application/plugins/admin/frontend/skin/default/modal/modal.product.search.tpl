<div id="modal-product-search" class="modal-window">
    <div class="modal-close"></div>
    <div class="modal-content">
        Название товара&nbsp;&nbsp; <input type="text" class="product autocomplete-pro" value="{$smarty.get.search}" >
        <small class="note">Начните вбивать название товара. Затем кликните по нужному, чтобы <b>добавить товар</b></small>
    </div>
</div>

{capture name="scripts"}
    <script>
      $('.product.autocomplete-pro').autocompletePro({
        name: 'products',
        url: ADMIN_URL + 'product/ajax/search/',
          {if $oCategory}
        url_search: ADMIN_URL + 'product/category/' + {$oCategory->getId()} + '/',
          {else}
        url_search: ADMIN_URL + 'product/',
          {/if}
        name_search: 'search',
        render: function (obj) {
          var item =
            '<div class="row" data-id="' + obj.id + '">' +
            '<span>' + obj.name + (obj.hide == 1 ? ' <span style="color:#d60000;">(скрыт)</span> ' : '') + '</span>' +
            '</div>';
          return item;
        }
      }, function (obj) {
        ls.ajax.load(ADMIN_URL + 'order/ajax/product/add/', {
          order_id: iOrderId,
          product_id: obj.id
        }, function(answ) {
          window.location.reload();
        });
      });
    </script>
{/capture}

{LS::Append('scripts', $smarty.capture.scripts)}