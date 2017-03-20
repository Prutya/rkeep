var GoodsEditor = function(container) {
  var container = container;

  var list = null;
  var cards = null;
  var popup = null;
  var popupWrapper = null;

  init();

  return {
    cards: cards,
    popup: popup,
    popupWrapper: popupWrapper
  };

  function init() {
    list = container.find('.goods-container__list');
    cards = list.find('.good');
    popupWrapper = container.find('.popup-wrapper');
    popup = popupWrapper.find('.good-popup');

    initPopup();
    initCards();
  }

  function initPopup() {
    var openButton = $('#trigger');
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
      var numberList = popup.find('select[name="good[quantity]"]');

      var goodId = selectList.val();
      var goodName = selectList.children('option').filter(':selected').text();
      var goodQuantity = parseInt(numberList.val());

      addCard({
        id: goodId,
        name: goodName,
        quantity: goodQuantity
      });

      closePopup();
    });
  }

  function initCards() {
    cards.each(function(index, item) {
      initCard($(item));
    });
  }

  function initCard(card) {
    var closeButton = card.find('.good__button--close');

    closeButton.click(function(e) {
      e.preventDefault();
      e.stopPropagation();
      hideCard(card);
    });

    card.click(function() {
      var isHidden = card.hasClass('good--hidden');

      if (isHidden) {
        showCard(card);
      }
    });

  }

  function openPopup() {
    popupWrapper.removeClass('popup-wrapper--hidden');
    $(document.body).addClass('noscroll');
  }

  function closePopup() {
    popupWrapper.addClass('popup-wrapper--hidden');
    $(document.body).removeClass('noscroll');
  }

  function addCard(props) {
    var element = findCard(props.id);

    if (element.length) {
      var numberInput = element.find('input[name="good[quantity]"]');
      var existingNumber = parseInt(numberInput.val());

      numberInput.val(existingNumber + props.quantity);
    } else {
      var template = $('#good-template').text();
      var rendered = Mustache.render(template, props);
      var element = $(rendered);

      initCard(element);

      list.append(element);
    }

    highlightCard(element);
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
      var itemId = item.data('good-id');

      return itemId.toString() === id;
    });
  }

  function hideCard(card) {
    card.addClass('good--hidden');
  }

  function showCard(card) {
    card.removeClass('good--hidden');
  }
}

$(function() {
  var goodsEditors = new GoodsEditor($('.goods-container'));
});
