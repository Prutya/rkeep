var GoodsEditor = function(container) {
  var container = container;
  var list = container.find('.goods-container__list');
  var popupWrapper = null;
  var popup = null;
  var billId = container.data('bill-id');
  var billItemTemplate = $('#bill-item-template').text();
  var billItemPopupTemplate = $('#bill-item-popup-template').text();
  var spinner = container.find('.goods-container__loader');
  var goods = null;

  init();

  return {list: list, popup: popup, popupWrapper: popupWrapper, billId: billId};

  function init() {
    if (container.length < 1) {
      return;
    }

    initCards();
    initGoods();
  }

  function initPopup() {
    var renderedPopup = Mustache.render(billItemPopupTemplate, {goods: goods});
    popupWrapper = $(renderedPopup);
    popup = popupWrapper.find('.good-popup');

    container.append(popupWrapper);

    var openButton = $('#good-popup-trigger');
    var closeButton = popup.find('.good-popup__button--close');
    var addButton = popup.find('.good-popup__footer__add-button');

    closeButton.click(function(e) {
      e.preventDefault();
      e.stopPropagation();
      closePopup();
    });

    openButton.click(function(e) {
      e.preventDefault();
      e.stopPropagation();
      openPopup();
    });

    popup.click(function(e) {
      e.preventDefault();
      e.stopPropagation();
    });

    popupWrapper.click(function(e) {
      e.preventDefault();
      e.stopPropagation();
      closePopup();
    });

    addButton.click(function(e) {
      e.preventDefault();

      var selectList = popup.find('select[name="good[id]"]');
      var numberList = popup.find('input[name="good[quantity]"]');

      var goodId = selectList.val();
      var goodQuantity = parseInt(numberList.val());

      closePopup();

      addItem({good_id: goodId, quantity: goodQuantity});
    });
  }

  function initCards() {
    loadBill().success(function(data) {
      data.bill.items.forEach(function(item) {
        var button_disabled = data.bill.closed_at || data.bill.cancelled_at
        addCard({item: item, button_disabled: button_disabled});
      });
      hideSpinner();
    }).error(function() {
      toastr.error('Error loading bill items.', 'Error');
    });
  }

  function initGoods() {
    return loadGoods().success(function(data) {
      goods = data.goods;
      initPopup();
    }).error(function() {
      toastr.error('Error loading goods list.', 'Error');
    });
  }

  function addCard(data, shouldHighlight = false) {
    var element = findCard(data.item.id);

    if (element.length > 0) {
      var numberInput = element.find('input[name="good[quantity]"]');
      var existingNumber = parseInt(numberInput.val());

      numberInput.val(data.item.quantity);
    } else {
      var rendered = Mustache.render(billItemTemplate, data);
      var element = $(rendered);

      initCard(element);

      list.append(element);
      setTimeout(function() {
        showCard(element)
      }, 5); // CSS transition hack
    }

    if (shouldHighlight) {
      highlightCard(element);
    }
  }

  function initCard(card) {
    var closeButton = card.find('.good__button--close');
    var itemId = card.data('bill-item-id');

    closeButton.click(function(e) {
      e.preventDefault();
      e.stopPropagation();

      if (!confirm('Are you sure?')) {
        return;
      }

      removeItem(itemId).success(function(data) {
        disableCard(card);
        updateBillInfo(data.bill_item.bill);
      }).error(function() {
        toastr.error('Failed to cancel bill item.', 'Error');
      });
    });
  }

  function openPopup() {
    popupWrapper.removeClass('popup-wrapper--hidden');
    $(document.body).addClass('noscroll');
  }

  function closePopup() {
    popupWrapper.addClass('popup-wrapper--hidden');
    $(document.body).removeClass('noscroll');

    popup.find('input[name="good[quantity]"]').val(1); // Set to default value
  }

  function highlightCard(card) {
    card.addClass('good--highlight');
    setTimeout(function() {
      card.removeClass('good--highlight');
    }, 1000);
  }

  function findCard(id) {
    return list.find('.good').filter(function(index) {
      var item = $(this);
      var itemId = item.data('bill-item-id');

      return itemId === id;
    });
  }

  function disableCard(card) {
    card.addClass('good--disabled');

    return card;
  }

  function enableCard(card) {
    card.removeClass('good--disabled');

    return card;
  }

  function hideCard(card) {
    card.addClass('good--hidden');

    return card;
  }

  function showCard(card) {
    card.removeClass('good--hidden');

    return card;
  }

  function showSpinner() {
    spinner.removeClass('goods-container__loader--hidden');
  }

  function hideSpinner() {
    spinner.addClass('goods-container__loader--hidden');
  }

  function updateBillInfo(options) {
    $('#bill-total').text(options.total);
    $('#bill-subtotal').text(options.subtotal);
  }

  function loadBill() {
    return $.ajax({
      url: '/api/v1/bills/' + billId,
      method: 'GET'
    });
  }

  function loadGoods() {
    return $.ajax({url: '/api/v1/goods', method: 'GET'});
  }

  function addItem(item) {
    $.ajax({
      url: '/api/v1/bills/' + billId + '/items',
      data: {
        bill_item: item
      },
      method: 'POST'
    }).success(function(data) {
      addCard({
        item: data.bill_item
      }, true);

      updateBillInfo(data.bill_item.bill);
    });
  }

  function removeItem(itemId) {
    return $.ajax({
      url: '/api/v1/bills/' + billId + '/items/' + itemId,
      method: 'DELETE'
    });
  }
}

$(function() {
  var goodsEditor = new GoodsEditor($('.goods-container'));
});
