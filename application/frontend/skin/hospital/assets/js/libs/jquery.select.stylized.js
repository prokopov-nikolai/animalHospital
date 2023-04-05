"use strict";
(function ($, window, document) {
    $.fn.selectStylized = function (options) {
        var aElements = this;

        aElements.each(function(i) {
            var oSelect = $(this);
            var oWrap = $('<div/>').addClass('select-stylized');
            var bIsMultiple = oSelect.attr('multiple');
            if (bIsMultiple) {
                oWrap.addClass('multiple')
            }
            if (bIsMultiple) {
                oWrap.append('<div class="_selected '+(oSelect.hasClass('_error') ? '_error' : '')+'" data-id="' + oSelect.attr('id') + '" data-value="'+ oSelect.val() +'"></div>');
                JoinValues();
            } else {
                oWrap.append('<div class="_selected '+(oSelect.hasClass('_error') ? '_error' : '')+'" data-id="' + oSelect.attr('id') + '" data-value="'+ oSelect.val() +'">' + oSelect.find(':selected').html() + '</div>');
            }
            var oOptions = $('<div/>').addClass('_options');
            oSelect.find('option').each(function(){
                oOptions.append('<div class="_option'+($(this).attr('selected') ? ' selected' : '')+'" data-value="'+$(this).attr('value')+'">'+$(this).html()+'</div>');
            });
            oOptions.find('._option').on('click', function(){
                if (bIsMultiple) {
                    if (oSelect.find('option[value="'+$(this).data('value')+'"]').prop('selected')) {
                        oSelect.find('option[value="' + $(this).data('value') + '"]').prop('selected', false);
                    } else {
                        oSelect.find('option[value="' + $(this).data('value') + '"]').prop('selected', true);
                    }
                    $(this).toggleClass('selected');
                    JoinValues();
                } else {
                    oWrap.find('._options').hide();
                    oWrap.find('._selected').html($(this).html());
                    oWrap.find('._selected').attr('data-value', $(this).data('value'));
                    oSelect.find('option[value="'+$(this).data('value')+'"]').prop('selected', true);
                }
                oSelect.trigger('change');
                return false;
            });
            oWrap.append(oOptions);
            oWrap.on('click', function(){
                if ($(this).find('._options').css('display') == 'block') {
                    $(this).find('._options').hide();
                } else {
                    $(this).find('._options').show();
                    // oOptions.mCustomScrollbar();
                }
                return false;
            });
            $(this).hide();
            $(this).after(oWrap);
            function JoinValues() {
                let aText = [],
                    aValue = [];
                oSelect.find(':selected').each(function(){
                    aText.push($(this).html().trim());
                    aValue.push($(this).data('value'));
                });
                oWrap.find('._selected').html(aText.length ? aText.join(', ') : '---');
                oWrap.find('._selected').attr('data-value', (aValue.length ? aValue.join(', ') : ''));
            }
        });

        $('body').on('click', function(){
            $('.select-stylized ._options').hide();
        });

        return this;
    }
})(jQuery, window, document);
